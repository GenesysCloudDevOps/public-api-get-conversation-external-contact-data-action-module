resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "conversationId" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "communicationId" = {
                "type" = "string"
            },
            "externalContactId" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/conversations/$${input.conversationId}"
        
    }

    config_response {
        success_template = "{ \"externalContactId\": $${successTemplateUtils.firstFromArray(\"$${externalContactId}\", \"$esc.quote$esc.quote\")}, \"communicationId\": $${successTemplateUtils.firstFromArray(\"$${communicationId}\", \"$esc.quote$esc.quote\")} }"
        translation_map = { 
			externalContactId = "$.participants[?(@.purpose=='customer' || @.purpose=='external')].externalContactId"
			communicationId = "$.participants[?(@.purpose=='customer' || @.purpose=='external')].calls[0].id"
		}
               
    }
}