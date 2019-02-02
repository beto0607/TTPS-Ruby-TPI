[Readme file](README.md)

## Endpoints ##

List of endpoints, expected request and normal response.

* `POST /users` 
    * Request: 
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
    * Response:
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
* `POST /sessions`
    * Request:
        ```
        {
            "user": {
                "username": "anUsername",
                "password": "aPassword",
                "password_confirmation": "aPassword"
            }
        }
        ```
    * Response:
        ```
        {
            "data": {
                "type": "user",
                "id": 1,
                "attributes":
                {
                    "token": "TOKEN",
                    "username": "anUsername",
                    "email": "an@email.com",
                    "screen_name": "Screen Name"
                }
            }
        }
        ```
* `GET /questions`
    * Request:
        ```
        Empty
        ```
    * Response:
        ```
        {
            "links": {
                "self": "URL from request",
                "next": "URL for next page, if exists",
                "previous": "URL for previous page, if exists"
            },
            "data": [
                {
                    "id": 1,
                    "type": "question",
                    "attributes":
                    {
                        "title": "Question title",
                        "description": "firsts 120 chars",
                        "answer_count": 10,
                        "solved": false
                    },
                    "link": {
                        "self": "URL for complete question" 
                    }
                }, 
                ...
            ]
        }
        ```