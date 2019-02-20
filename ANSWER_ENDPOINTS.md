### Home ###
* [Readme file](README.md)
### List of endpoints ###
* [List of Endpoints](ENDPOINTS.md)

### Endpoints for Questions ###

* `GET /questions/:question_id/answers`
    * **Request:**
        ```
        Empty
        ```
    * **Response - Without errors:**
        * **HTTP code:** 200 - Ok
        ```
        {
            "data": [
                {
                    "id": "1",
                    "type": "answers",
                    "links": {
                        "question": "/questions/1"
                    },
                    "attributes": {
                        "user_id": 3,
                        "question_id": 1,
                        "content": "Eum dolores expedita."
                    }
                }, ...
            ]
        }
        ```
    * **Response - Not found**
        * **HTTP code:** 404 - Not found
        ```
        {
            "error": {
                "title": "Question #XX not found"
            }
        }
        ```
* `POST /questions/:question_id/answers`
    * **Request:**
        * **Header**
        ```
        X-QA-Key: [User token]
        ```
        * **Body**
        ```
        {
            answer:{
                content: "aContent"
            }
        }
        ```
    * **Response - Without errors:**
        * **HTTP code:** 200 - Ok
        ```
        {
            "data": {
                "id": "4",
                "type": "answers",
                "links": {
                    "question": "/questions/1"
                },
                "attributes": {
                    "user_id": 1,
                    "question_id": 1,
                    "content": "aContent"
                }
            }
        }
        ```
    * **Response - Not found**
        * **HTTP code:** 404 - Not found
        ```
        {
            "error": {
                "title": "Question #XX not found"
            }
        }
        ```
    * **Response - Not params**
        * **HTTP code:** 400 - Bad request
        ```
        {
            "error": {
                "title": "Params required: answer{content}"
            }
        }
        ```
    * **Response - Question solved**
        * **HTTP code:** 422 - Unprocessable entity
        ```
        {
            "error": {
                "title": "Question #2 is already solved."
            }
        }
        ```
    * **Response - No token**
        * **HTTP code:** 401 - Unauthorized
        ```
        {
            "errors": "User must be authenticated."
        }
        ```
* `DELETE /questions/:question_id/answers/:answer_id`
    * **Request:**
        * **Header**
        ```
        X-QA-Key: [User token]
        ```
        * **Body**
        ```
        Empty
        ```
    * **Response - Without errors:**
        * **HTTP code:** 204 - No content
        ```
        Empty
        ```
    * **Response - Question not found**
        * **HTTP code:** 404 - Not found
        ```
        {
            "error": {
                "title": "Question #XX not found"
            }
        }
        ```
    * **Response - Answer not found**
        * **HTTP code:** 404 - Not found
        ```
        {
            "error": {
                "title": "Answer #XX not found"
            }
        }
        ```
    * **Response - Question solved**
        * **HTTP code:** 422 - Unprocessable entity
        ```
        {
            "error": {
                "title": "Answer is solution for #XX. Cannot be deleted."
            }
        }
        ```
    * **Response - No token**
        * **HTTP code:** 401 - Unauthorized
        ```
        {
            "errors": "User must be authenticated."
        }
        ```             