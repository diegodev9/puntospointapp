# frozen_string_literal: true

module Api
  module V1
    # api controller
    class ApiController < ApplicationController
      before_action :authenticate_user!
      before_action :most_bought, only: %i[mas_comprados mas_recaudado]
      respond_to :json

      def mas_comprados
        _arr = []

        @most_bought.each do |(categories, product), qty|
          _categories = categories.each.map { |cat| Category.find(cat).name }
          _product = Product.find(product).name
          _qty = qty

          _arr << { producto: _product, categorias: _categories, ventas: _qty }
        end

        if _arr == []
          render json: { 'message': 'se necesitan mas ventas para calcular' }
        else
          render json: { 'mas_comprados': _arr }
        end
      end

      def mas_recaudado
        _arr = []

        @most_bought.first(3).each do |(categories, product), qty|
          _categories = categories.each.map { |cat| Category.find(cat).name }
          _product = Product.find(product)
          _product_name = _product.name
          _product_price = _product.price
          _ventas_total = _product_price * qty

          _arr << { producto: _product_name, precio: _product_price, categorias: _categories, ventas: qty, total: _ventas_total }
        end

        if _arr == []
          render json: { 'message': 'se necesitan mas ventas para calcular' }
        else
          render json: { 'mas_recaudado': _arr }
        end
      end

      def listar_compras
        if listar_compras_params[:fecha_desde].present? && listar_compras_params[:fecha_hasta].present?
          compras = compras(listar_compras_params)
          render json: { 'listado_de_compras':
                           { 'params': listar_compras_params,
                             'resultado': compras.each.map do |compra|
                               {
                                 id: compra.id,
                                 user_id: compra.user_id,
                                 product_id: compra.product_id,
                                 category: compra.category,
                                 created_at: l(compra.created_at, format: '%d-%m-%y'),
                                 owner: compra.owner
                               }
                             end } }
        else
          render json: { 'message': 'fecha_desde y fecha_hasta deben estar presentes' }
        end
      end

      def cantidad_compras
        if cantidad_compras_params[:granularidad].present?
          compras = compras(cantidad_compras_params)
          granularidad = cantidad_compras_params[:granularidad]
          _granularidad = []

          case granularidad
          when 'año'
            (cantidad_compras_params[:fecha_desde].to_date.year..cantidad_compras_params[:fecha_hasta].to_date.year).each do |year|
              cantidad = compras.map { |compra| compra if compra.created_at.to_datetime.year == year }.compact.count
              _granularidad << "#{year}: #{cantidad}"
            end
          when 'semana'
            (cantidad_compras_params[:fecha_desde].to_date.cweek..cantidad_compras_params[:fecha_hasta].to_date.cweek).each do |week|
              cantidad = compras.map { |compra| compra if compra.created_at.to_date.cweek == week }.compact.count
              _granularidad << "#{week}: #{cantidad}"
            end
          when 'dia'
            (cantidad_compras_params[:fecha_desde].to_date.yday..cantidad_compras_params[:fecha_hasta].to_date.yday).each do |yday|
              cantidad = compras.map { |compra| compra if compra.created_at.to_date.yday == yday }.compact.count
              _granularidad << "#{Date.ordinal(cantidad_compras_params[:fecha_desde].to_date.year, yday)}: #{cantidad}"
            end
          when 'hora'
            (cantidad_compras_params[:fecha_desde].to_datetime..cantidad_compras_params[:fecha_hasta].to_datetime).each do |day|
              (0..23).each do |num_hour|
                _hour_begin = day + num_hour.hour
                _hour_end = _hour_begin + 59.minutes
                cantidad = compras.map { |compra| compra if compra.created_at.to_datetime.between?(_hour_begin, _hour_end) }.compact.count
                _granularidad << "#{l(day, format: '%d-%m-%Y %H:%M')}: #{cantidad}"
              end
            end
          end

          render json: { 'cantidad_de_compras': {
            'params': cantidad_compras_params,
            'resultado': compras.map do |compra|
              {
                id: compra.id,
                user_id: compra.user_id,
                product_id: compra.product_id,
                category: compra.category,
                created_at: l(compra.created_at, format: '%d-%m-%y'),
                owner: compra.owner
              }
            end,
            'granularidad': _granularidad
          } }
        else
          render json: { 'message': 'parámetro incorrecto' }
        end
      end

      private

      def compras(params)
        fecha_inicio = params[:fecha_desde].to_datetime.beginning_of_day.in_time_zone.utc
        fecha_fin = params[:fecha_hasta].to_datetime.end_of_day.in_time_zone.utc
        created_at = [fecha_inicio..fecha_fin]
        category_id = params[:category] || nil

        purchases = Purchase.where(created_at: created_at)
        if params[:granularidad].present?
          params_select = params.select { |k, v| [k.to_sym, v] if v.present? && k != 'fecha_desde' && k != 'fecha_hasta' && k != 'category' && k != 'granularidad' }
        else
          params_select = params.select { |k, v| [k.to_sym, v] if v.present? && k != 'fecha_desde' && k != 'fecha_hasta' && k != 'category' }
        end
        # search_params = params_select.to_enum.each { |param| ["#{param.first} LIKE ?", param.last]}

        if params[:category].present?
          purchases.where(params_select).map { |pur| pur if pur.category.scan(/\d./).include?(category_id) }.compact
        else
          purchases.where(params_select)
        end
      end

      def most_bought
        purchases = Purchase.all.includes([:product]).map { |purchase| [purchase.product.category_ids, purchase.product.id] }
        groups = purchases.group_by(&:itself)
        counts = groups.map { |value, group| [value, group.count] }
        duplicates = counts.select { |value, count| count > 1 }
        # [[[categorias], producto], veces_vendido]
        @most_bought = duplicates.sort_by(&:last).reverse
      end

      def listar_compras_params
        params.require(:listar_compras).permit(:fecha_desde, :fecha_hasta, :category, :user_id, :owner)
      end

      def cantidad_compras_params
        params.require(:cantidad_compras).permit(:fecha_desde, :fecha_hasta, :category, :user_id, :owner, :granularidad)
      end
    end
  end
end
