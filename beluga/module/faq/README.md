Faq module's doc
===================

The __faq__ module allows you to create and handle faqs easily. If you want to administrate category and / or faq's entries, you will need the __account__ module provided by Beluga.

This module offers a few numbers of methods to easily integrate it inside your project.

Here are the methods provided by this module :

```Haxe
public function redirectEditFAQ() : Bool
public function getCurrentCategory() : CategoryModel
public function createFAQ(args : {
    question : String,
    answer : String,
    category_id : Int
}) : Void
public function createCategory(args : {name : String, parent: Int}) : Void
public function deleteFAQ(args : {question_id : Int, category_id : Int}) : Void
public function deleteCategory(args : {category_id : Int, parent_id: Int}) : Void
public function editCategory(args : {category_id: Int, name : String}) : Void
public function editFAQ(args : {faq_id: Int, question : String, answer : String}) : Void
public function getAllCategories() : Array<CategoryModel>
```

##Triggers

This module can send back the following triggers :

 * defaultPage
 * deleteFail
 * deleteSuccess
 * createFail
 * createSuccess
 * editFail
 * editSuccess
 * createCategoryFail
 * createCategorySuccess
 * deleteCategoryFail
 * deleteCategorySuccess
 * editCategoryFail
 * editCategorySuccess
 * redirectCreateFAQ
 * redirectCreateCategory
 * print
 * redirectEditCategory
 * redirectEditFAQ
 * edit
 * create
 * delete

##Errors

In case of failure, just check the error code to know what's wrong. Here is the full errors list for the faq module :

 * __UnknownCategory__ : The requested category doesn't exist.
 * __MissingQuestion__ : The question is missing.
 * __MissingLogin__ : You need to be logged in.
 * __MissingAnswer__ : The answer is missing.
 * __MissingName__ : The name is missing.
 * __EntryAlreadyExists__ : This FAQ already exists.
 * __CategoryAlreadyExists__ : This category already exists.
 * __IdNotFound__ : The requested faq doesn't exist.
 * __None__ : No error occured.

##Methods description

For example, the createFAQ method sends back the `createSuccess` trigger or the `createFail` trigger. Then you just have to handle them and display according to the one you will receive.

```Haxe
public function redirectEditFAQ() : Bool
```

This method is used to check if the current faq does exist. This method will change in a next version.

```Haxe
public function getCurrentCategory() : CategoryModel
```

This method returns the current category or null if it doesn't exist.

```Haxe
public function createFAQ(args : {
    question : String,
    answer : String,
    category_id : Int
}) : Void
```

The createFAQ method takes the question, the answer and the category in which it will be created as parameters. It sends back the `createSuccess` trigger or the `createFail` trigger. If it fails, please check the error code returned to know the reason.

```Haxe
public function createCategory(args : {name : String, parent: Int}) : Void
```

The createCategory method takes a name and the parent id (-1 if the parent is the root) as parameters. It sends back the `createCategoryFail` trigger or the `createCategorySuccess` trigger. If it fails, please check the error code returned to know the reason.

```Haxe
public function deleteFAQ(args : {question_id : Int, category_id : Int}) : Void
```

The deleteFAQ method takes the FAQ id to delete and the category id in which it belongs. It sends back the `deleteFail` trigger or the `deleteSuccess` trigger. If it fails, please check the error code returned to know the reason.

```Haxe
public function deleteCategory(args : {category_id : Int, parent_id: Int}) : Void
```

The deleteCategory method takes the category id to delete and its parent id. It sends back the `deleteCategoryFail` trigger or the `deleteCategorySuccess` trigger. If it fails, please check the error code returned to know the reason.

```Haxe
public function editCategory(args : {category_id: Int, name : String}) : Void
```

The editCategory method takes the category id to edit and the new name. It sends back the `editCategoryFail` trigger or the `editCategorySuccess` trigger. If it fails, please check the error code returned to know the reason.

```Haxe
public function editFAQ(args : {faq_id: Int, question : String, answer : String}) : Void
```

The editFAQ method takes the faq id to edit, the new question and the new answer. It sends back the `editFail` trigger or the `editSuccess` trigger. If it fails, please check the error code returned to know the reason.

```Haxe
public function getAllCategories() : Array<CategoryModel>
```

The getAllcategories method returns the list of all the existing categories. It can returns an empty Array.
