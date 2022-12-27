(function($) {

	"use strict";

	$("#decode").click(() => {
		$("#action_type").val("decode");
	})
	$("#encode").click(() => {
		$("#action_type").val("encode");
	})

  // Form
	var contactForm = function() {
		if ($('#contactForm').length > 0 ) {
			$("#contactForm" ).validate( {
				rules: {
					url: "required"
				},
				messages: {
					url: "Please enter your URL"
				},

				submitHandler: function(form) {
					var $submit = $('.submitting'), waitText = 'Submitting...';
					var url, type;
					if ($("#action_type").val() == "encode") {
						type = "POST";
						url = "api/v1/urls/encode";
					}
					else {
						type = "GET";
						url = "api/v1/urls/decode";
					}

					$.ajax({
							type: type,
							url: url,
				      data: $(form).serialize(),

				      beforeSend: function() {
				      	$submit.css('display', 'block').text(waitText);
				      	$('#form-message-warning').hide();
		            $('#form-message-success').hide();
				      },
				      success: function(result) {
			          setTimeout(function(){
	             		$('#contactForm').fadeIn();
	             	}, 1000);

		            var result_url;
		            if (type == "POST") {
		            	result_url = result['data']['alias_url']
		            }
		            else {
		            	result_url = result['data']['original_url']
		            }
		            $('#form-message-success').html(result_url);

		            setTimeout(function(){
		               $('#form-message-success').fadeIn();
               	}, 1400);

               	setTimeout(function(){
	              	$submit.css('display', 'none').text(waitText);
	               }, 1400);
				      },
				      error: function(res) {
				      	$('#form-message-warning').html("Something went wrong. Please try again.");
				        $('#form-message-warning').fadeIn();
				        $submit.css('display', 'none');
				      }
			      });    		
		  		}
			});
		}
	};
	contactForm();

})(jQuery);
