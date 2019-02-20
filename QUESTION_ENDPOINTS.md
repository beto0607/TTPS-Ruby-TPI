### Home ###
* [Readme file](README.md)
### List of endpoints ###
* [List of Endpoints](ENDPOINTS.md)

### Endpoints for Questions ###

* `GET /questions[?sort=(needing_help|pending_first|latest)]` default for sort: latest
    * **Request:**
        ```
        Empty
        ```
    * **Response _ Without errors:**
        * **HTTP code:** 200 - Ok
        ```
        {
            "data": [
                {
                    "id": "2",
                    "type": "questions",
                    "links": {
                        "self": "/questions/2"
                    },
                    "attributes": {
                        "title": "aTitle",
                        "user_id": 3,
                        "answer_count": 1,
                        "status": true,
                        "answer_id": 2,
                        "description-short": "aShortDescription.",
                        "created_at": "2019-02-06T18:14:25.705Z",
                        "updated_at": "2019-02-06T18:14:25.710Z"
                    }
                }, ...
            ]
        }
        ```

* `GET /questions/:id[?answers=true]`
    * **Request:**
        ```
        Empty
        ```
    * **Response - Without errors - Without answers:**
        * **HTTP code:** 200 - Ok
        ```
        {
            "data": {
                "id": "1",
                "type": "questions",
                "links": {
                    "self": "/questions/1"
                },
                "attributes": {
                    "title": "aTitle",
                    "user_id": 2,
                    "answer_count": 1,
                    "status": false,
                    "answer_id": null,
                    "description": "aDescription",
                    "created_at": "2019-02-06T18:14:25.693Z",
                    "updated_at": "2019-02-06T18:14:25.693Z"
                }
            }
        }
        ```
    * **Response - Without errors - With answers:**
        * **HTTP code:** 200 - Ok
        ```
        {
            "data": {
                "id": "1",
                "type": "questions",
                "links": {
                    "self": "/questions/1"
                },
                "attributes": {
                    "title": "aTitle",
                    "user_id": 2,
                    "answer_count": 1,
                    "status": false,
                    "answer_id": null,
                    "description": "aDescription",
                    "created_at": "2019-02-06T18:14:25.693Z",
                    "updated_at": "2019-02-06T18:14:25.693Z"
                }
            },
            "included": [
                {
                    "id": "1",
                    "type": "answers",
                    "links": {
                        "question": "/questions/1"
                    },
                    "attributes": {
                        "user_id": 3,
                        "question_id": 1,
                        "content": "answerContent."
                    }
                }
            ]
        }
        ```
    * **Response - With error:**
        * **HTTP code:** 404 - Not_found
        ```
        {
            "error": {
                "title": "Question #12344 not found"
            }
        }
        ```

* `POST /questions`
    * **Request**
        * **Header**
        ```
        X-QA-Key: [User token]
        ```
        * **Body**
        ```
        {
            "question":{
                "description":"aDescription",
                "title":"aTitle"
            }
        }
        ```
    * **Response - Without error**
        * **HTTP code:** 201 - Created
        ```
        {
            "data": {
                "id": "5",
                "type": "questions",
                "links": {
                    "self": "/questions/5"
                },
                "attributes": {
                    "title": "aTitle",
                    "user_id": 1,
                    "answer_count": 0,
                    "status": false,
                    "answer_id": null,
                    "description": "aDescription",
                    "created_at": "2019-02-08T23:40:02.430Z",
                    "updated_at": "2019-02-08T23:40:02.430Z"
                }
            }
        }
        ```
    * **Response - With error - No title**
        * **HTTP code:** 422 - Unprocessable entity
        ```
        {
            "data": {
                "title": [
                    "can't be blank"
                ]
            }
        }
        ```
    * **Response - With error - No user**
        * **HTTP code:** 401 - Unauthorized
        ```
        Empty
        ```

* `PUT/PATCH /questions/:question_id`
    * **Request**
        * **Header**
        ```
        X-QA-Key: [User token]
        ```
        * **Body**
        ```
        {
            "question":{
                "title":"aTitle1",
                "description":"aDescription2"
            }
        }
        ```
    * **Response - Without error**
        * **HTTP code:** 200 - Ok
        ```
        {
            "data": {
                "id": "6",
                "type": "questions",
                "links": {
                    "self": "/questions/6"
                },
                "attributes": {
                    "title": "aTitle1",
                    "user_id": 1,
                    "answer_count": 0,
                    "status": false,
                    "answer_id": null,
                    "description": "aDescription2",
                    "created_at": "2019-02-08T23:44:05.301Z",
                    "updated_at": "2019-02-08T23:44:05.301Z"
                }
            }
        }
        ```
    * **Response - With error - Not found**
        * **HTTP code:** 404 - Bad request
        ```
        {
            "error": {
                "title": "Question #XXX not found"
            }
        }
        ```
    * **Response - With error - No params**
        * **HTTP code:** 400 - Bad request
        ```
        {
            "error": {
                title:"Params required: title, description, question_id"
            }
        }
        ```
    * **Response - With error - No user or user isn't the owner**
        * **HTTP code:** 401 - Unauthorized
        ```
        Empty
        ```
* `DELETE /questions/:quesion_id`
    * **Request**
        * **Header**
        ```
        X-QA-Key: [User token]
        ```
    * **Response - Without error**
        * **HTTP code:** 204 - No content
        ```
        Empty
        ```
    * **Response - With error - Not found**
        * **HTTP code:** 404 - Bad request
        ```
        {
            "error": {
                "title": "Question #XXX not found"
            }
        }
        ```
    * **Response - With error - Has answers**
        * **HTTP code:** 422 - Unprocessable entity
        ```
        {
            "error": {
                "title":"Question #4 has answers"
            }
        }
        ```
    * **Response - With error - No user or user isn't the owner**
        * **HTTP code:** 401 - Unauthorized
        ```
        Empty
        ```
* `PUT /questions/:quesion_id/resolve`
    * **Request**
        * **Header**
        ```
        X-QA-Key: [User token]
        ```
        * **Body**
        ```
        {
            answer_id: 1
        }
        ```
    * **Response - Without error**
        * **HTTP code:** 200 - Ok
        ```
        {
            "data": {
                "id": "6",
                "type": "questions",
                "links": {
                    "self": "/questions/6"
                },
                "attributes": {
                    "title": "aTitle1",
                    "user_id": 1,
                    "answer_count": 0,
                    "status": true,
                    "answer_id": 1,
                    "description": "aDescription2",
                    "created_at": "2019-02-08T23:44:05.301Z",
                    "updated_at": "2019-02-08T23:44:05.301Z"
                }
            }
        }
        ```
    * **Response - With error - Question not found**
        * **HTTP code:** 404 - Not found
        ```
        {
            "error": {
                "title": "Question #XX not found"
            }
        }
        ``` 
    * **Response - With error - Answer doesn't belogs to Question**
        * **HTTP code:** 400 - Bad request
        ```
        {
            "error": {
                "title": "Answer #21 doesn't belong to Question #2."
            }
        }
        ``` 
    * **Response - With error - Already solved**
        * **HTTP code:** 422 - Unprocessable entity
        ```
        {
            "error": {
                "title":"Question #2 is already solved."
            }
        }
        ```
    * **Response - With error - No user or user isn't the owner**
        * **HTTP code:** 401 - Unauthorized
        ```
        Empty
        ```