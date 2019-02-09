### Home ###
* [Readme file](README.md)
### List of endpoints ###
* [List of Endpoints](ENDPOINTS.md)

### Endpoints for Users ###
* `POST /users` 
    * **Request:**
        ```
        {
            "user": {
                "username": "anUsername",
                "email": "an@email.com",
                "password": "aPassword",
                "password_confirmation": "aPassword",
                "screen_name": "Screen Name"
            }
        }
        ```
    * **Response - Without errors:**
        * **HTTP code:** 201 - Created
        ```
        {
            "data": {
                "type": "user",
                "id": 1,
                "attributes":
                {
                    "username": "anUsername",
                    "email": "an@email.com",
                    "screen_name": "Screen Name"
                }
            }
        }
        ```
    * **Response - With errors:**
        * **HTTP code:** 422 - Unprocessable Entity
        ```
        {
            "errors": {
                "username": [
                    "has already been taken"
                ],
                "email": [
                    "has already been taken"
                ]
            }
        }
        ```
* `POST /sessions`
    * **Request:**
        ```
        {
            "auth": {
                "username": "anUsername",
                "password": "aPassword"
            }
        }
        ```
    * **Response:**
        * **HTTP code:** 200 - Ok
        ```
        {
            "token": "aToken",
            "user":{
                "data": {
                    "id": 1,
                    "type": "users",
                    "attributes":
                    {
                        "username": "anUsername",
                        "email": "an@email.com",
                        "screen_name": "Screen Name"
                    }
                }
            }
        }
        ```
    * **Response - With errors:**
        * **HTTP code:** 404 - Not found
        ```
        {
            "error": {
                "title": "User not found"
            }
        }
        ```