//
//  InfoApi.swift
//  InfoApp
//
//  Created by Anil Gupta on 22/05/20.
//  Copyright © 2020 Anil Gupta. All rights reserved.
//

import Foundation
import UIKit

func getInfoApiString() -> String {
    
    let jsonResponse = """
    {
    "pages": [
    {
    "title": "Kindly Enter Your Name",
    "subtitle": "Name you mentioned will be displayed on profile screen",
    "placeholderText": "Ximena Avila",
    "canMoveNext": true,
    "nextButtonText": "NEXT",
    "showNumberKeyoard":false,
    "emptyFieldMsg": "*Name is mandatory field",
    "isSummary": false,
    "parameterKey": "Name"
    },
    {
      "title": "Kindly Enter Your Phone Number",
      "subtitle": "Number you mentioned will be displayed on profile screen",
      "placeholderText": "8989898989",
      "canMoveNext": true,
      "nextButtonText": "NEXT",
      "showNumberKeyoard":true,
      "emptyFieldMsg": "*Number is mandatory field",
      "isSummary": false,
      "parameterKey": "Phone"
    },
    {
      "title": "Describe Yourself",
      "subtitle": "Summary you mentioned will be displayed on profile screen",
      "placeholderText": "Summary",
      "canMoveNext": false,
      "nextButtonText": "SUBMIT",
      "showNumberKeyoard":false,
      "emptyFieldMsg": "*Summary is mandatory field",
      "isSummary": true,
      "parameterKey": "Summary"
    }
    ]
    }
    """
        
    return jsonResponse
}
    
// Function to parse JSON
func parseJSON(data: Data) -> InfoDataArray? {
    var returnValue: InfoDataArray?
    do {
        returnValue = try JSONDecoder().decode(InfoDataArray.self, from: data)
    } catch {
        print("parseJSON Error took place: \(error.localizedDescription).")
    }
    return returnValue
}

