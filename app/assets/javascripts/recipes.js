// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var current_ingredients = 1;

$(document).on("click", "#ingredientAddButton",  function(){
        var clonedIngredient = $("#ingredientSelect").clone();

        current_ingredients = current_ingredients + 1;

        var modifiedIngredient = clonedIngredient.prop('outerHTML').replace(/ingredient1/g,"ingredient" + current_ingredients);

        $("#ingredientAddButtonRow").before(modifiedIngredient);
});

function discard(id, unlike) {

    var maxidElement = $("[data-maximum-recipe-id]");
    var maxid = maxidElement.data("maximumRecipeId");

    var request = new XMLHttpRequest();
    request.responseType = "text";
    request.onreadystatechange = function(){
        if (request.readyState == 4 && request.status == 200)
        {
            var toReplace = $("#ingred" + id)[0];
            toReplace.outerHTML = request.responseText;
            var tempIdElement = $("[data-temp-id]");
            var tempId = tempIdElement.data("tempId");
            console.log(tempId);
            maxidElement.data("maximumRecipeId",tempId);
            tempIdElement.remove();
        }
    };

    var unlikeString = "";
    if (unlike) {
        unlikeString="&unlike="+id;
    }

    request.open("GET","/recipes/getnext?maxid=" + maxid + "&t=" + Math.random() + unlikeString,true);
    request.send();
}