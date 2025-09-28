# Flutter Crud App - Phol Castañeda

Consiste en una aplicación móvil desarrollada en flutter que consume datos de usuarios desde la API REST pública gratuita de **[DummyJSON](https://dummyjson.com)**. La aplicación permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre los registros de usuarios obtenidos de la API. La navegación entre pantallas está implementada para mostrar la lista de usuarios, detalles de un usuario individual y el formulario para crear o editar registros. Además, también se encuentra la funcionalidad para eliminar registros desde la lista o la pantalla de detalles.

--- 

## Estructura de Archivos

Se usó la estructura de archivos indicada:
- **models** → clases de datos.
- **services** → comunicación con la API.
- **providers** → gestión del estado.
- **screens** → pantallas

## Explicación de la API seleccionada

La API DummyJSON proporciona un conjunto de datos de usuarios falsos junto con información relacionada como carts, posts y tareas. Ofrece las operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre usuarios pero no modifica los datos en el servidor real. Documentación de DummyJSON para usuarios: **[DummyJSON DOCS](https://dummyjson.com/docs/users)**

### Endpoints Utilizados

#### 1. Obtener todos los usuarios  
`GET https://dummyjson.com/users`
Se obtiene una lista de usuarios. Por defecto, la API devuelve 30 registros. Se pueden usar los parámetros **limit** y **skip** para paginar los resultados, o en el caso de la aplicación, se usa un scroll infinito con ayuda de **limit** y **skip**.
**Parámetros**:
- **limit**: Número máximo de usuarios a retornar (por defecto 30).
- **skip**: Número de usuarios a omitir (útil para paginación).

---
#### 2. Agregar un nuevo usuario  
`POST https://dummyjson.com/users/add`
Agrega un usuario con la solicitud POST. No se almacena el usuario en el servidor real, pero devuelve un nuevo usuario con un ID generado, el id 209.

#### 3. Actualizar un usuario  
`PATCH https://dummyjson.com/users/{id}`  
Actualiza un usuario existente. Simula la operación PUT/PATCH y devuelve el usuario con los datos modificados.

**Parámetros:**
- **{id}**: ID del usuario que se desea actualizar. 

---

#### 4. Eliminar un usuario  
`DELETE https://dummyjson.com/users/{id}` 
Se elimina un usuario, simulando una solicitud DELETE. La API devuelve el usuario eliminado con las claves **isDeleted** y **deletedOn**.

**Parámetros:**
- **{id}**: ID del usuario a eliminar.

---

[Video mostrando el funcionamiento de la aplicación](https://drive.google.com/file/d/13G6xD524c0WY6uBtCUk2mYU8dSAt6ZJv/view?usp=sharing)

Se recomienda ver el video en 1080p y a 1.5 de velocidad
