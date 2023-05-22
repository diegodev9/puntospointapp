
# Appdemo

Carrito de compra desafio puntospoint


## Autor

- [@diegodev9](https://www.gitlab.com/diegodev9)


## Instalación
Requerimientos
- Node 16.13.1
- Yarn
- Ruby 3.1.2
- Rails 6.1.7.3
- redis-server 7.0.11
- Sidekiq 7.1.0

```bash
  bundle install
  yarn install
  rails db:create
  rails db:migrate
  rails db:seed
  sidekiq
  rails s
```

## Logueo

email: admin1@admin.com, password: 123456

email: client1@client.com, password 123456




## Desafío

Desarrollador Backend: Desafío Técnico

### I. Objetivo

El objetivo de este documento es describir los requerimientos necesarios para evaluar a
los talentos que quieran ser parte del equipo de Desarrollo y Tecnología en Puntospoint.

Con esto, equipo evaluador de Puntospoint sabrá, con más certeza, el conocimiento
técnico y habilidades de análisis de cada postulante.

Es importante que el postulante, una vez leído el requerimiento, habiendo resuelto dudas
de existir, informe vía correo electrónico, la fecha con el que se compromete para la
entrega de este desafío

### II. Requerimientos

Haciendo uso de una aplicación desarrollada con Ruby on Rails, respecto a un
ecommerce, se necesita:

Requerimientos funcionales:

    1. Tener registro de Productos, Categorías de Productos, Compras y Clientes que compran.
    2. Habrán distintos tipos de productos y cada producto podría estar asociado a una o más categorías. Cada producto debe tener una o más imágenes.
    3. Las compras registradas deben estar asociadas a un Producto y Cliente en Particular.
    4. Distintos usuarios Administradores gestionarán cada uno de los recursos por lo que al menos se necesita saber qué usuario Administrador fue el que crea Productos y Categorías. Deseable es saber qué usuarios hicieron algún cambio de estos recursos y cuáles serían esos cambios.
    5. Cada 1era compra de un producto se debe enviar un email a los usuarios Administradores, debe estar dirigido al creador del producto y en copia a los demás administradores.
    6. A diario se debe ejecutar un proceso que genere un reporte con las Compras realizadas de cada producto del día anterior y debe ser enviado a los Administradores.

Requerimientos técnicos:

    1. Se deben crear los modelos necesarios para cumplir con los requerimientos funcionales, sus asociaciones respectivas y tablas en la base de datos Postgresql para tener registro de los recursos. Los atributos de cada modelo, deben ser lo que el postulante estime necesario para que se cumplan los requerimientos funcionales.
    2. No es necesario implementar una vista de administración, solo que existan los modelos y que desde seeds se puedan crear una cantidad aceptable de recursos: Administradores, Productos, Categorías, etc. 
    3. Se deben crear 4 APIs JSON, con autenticación de usuarios Administradores utilizando JWT: 
        a. Obtener los Productos más comprados por cada categoría.
        b. Obtener los 3 Productos que más han recaudado ($) por categoría.
        c. Obtener listado de compras según parámetros. Los parámetros deben ser:    
            fecha de compra (desde y hasta), id categoría, id de cliente, Id Administrador (compras de productos asociado a cierto Id de Administrador).
        d. Obtener cantidad de compras según granularidad. Se debe considerar misma parametría del punto anterior + el parámetro de granularidad que puede ser: hora, día, semana, año. Se debe considerar que esta información la utilizará un Frontend para un gráfico. Ejemplos: i. Si es por hora, se espera como respuesta de la API: { 2023-05-01 00:00: 10, 2023-05-01 01:00: 40, …}. ii. Si es por día:{2023-05-01: 100, 2023-05-02: 250, …}
    4. Solo Administradores podrían acceder a estas APIs con autenticación y estas APIs debe ser testeadas utilizando Rspec.
    5. Se esperaría ver la implementación de asociaciones entre modelos más allá de las básicas. Por ejemplo: many to many, polimorfismo o herencia, según postulantes estime necesarias.
    6. Implementación de proceso diario respecto a reportería de compras diaria debe ser implementado con Sidekiq.
    7. Todo el código fuente se evaluará considerando los siguiente: 
        a. Alto Rendimiento: Consultas SQL optimizadas, utilización cachés,implementación de trabajos en segundo plano, sin n+1, u otros.
        b. Foco en la Seguridad: Uso estándar de seguridad recomendado por Ruby on Rails, registro correcto de credenciales privadas de ser requeridas, etc.  
        c. Implementación de Buenas prácticas: CI/CD, Linters, testing, recomendaciones de frameworks, patrones de diseño u otros.
    8. Se probará el envío del email de 1era compra de producto bajo condición de carrera.
    9. Deseables pero no requeridos:
        a. Que la(s) APIs tengan implementado algún mecanismo de caché.
        b. Lógica de modelos implementada que permita tener registro de qué usuario Administrado hizo algún cambio.
        c. Diagrama de entidad relación de los modelos.

### III. Entregable
    1. Aplicación Ruby o Rails, con la versión que postulante estime conveniente, con todo lo implementado y necesario según los requerimientos.
    2. Compartir código fuente a través de un repositorio a la cuenta en cparram en Github.
    3. Seeds para rellenar Base de Datos postgresql de manera local.
    4. Archivo Postman con las llamadas a las APIs o en su defecto script curl para ejecutar desde consola y probar cada API.

