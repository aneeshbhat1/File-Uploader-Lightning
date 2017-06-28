/**
 * Created by Archana on 28-06-2017.
 */
({
    upload: function(component, file, base64Data, callback) {
            var action = component.get("c.upload");
            action.setParams({
                fileName: file.name,
                content: base64Data
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    callback(a.getReturnValue());
                } else if (state === 'ERROR') {
                    var errors = a.getError();
                    console.log(errors);
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                } else if (state === "INCOMPLETE") {
                    console.log("Incomplete");
                }

            });
            $A.enqueueAction(action);
        },
        show: function (cmp, event) {
          var spinner = cmp.find("progressBar");
          $A.util.removeClass(spinner, "slds-hide");
          $A.util.addClass(spinner, "slds-show");
        },
        hide:function (cmp, event) {
                       var spinner = cmp.find("progressBar");
                       $A.util.removeClass(spinner, "slds-show");
                       $A.util.addClass(spinner, "slds-hide");
                     }
})