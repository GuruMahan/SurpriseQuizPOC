//
//  SurpriseQuizModel.swift
//  Surprise QuizUI Demo
//
//  Created by Guru Mahan on 19/01/23.
//

import Foundation
import UIKit

struct CreateQuestionModel: Identifiable{
  var id: String = UUID().uuidString
  var name: String = ""
  var placeHolder = ""
  var text: String = ""
  var questionImageModel: [QuestionImageModel] = []
  var attachments: [String] = []
  var options: [CreateOptionModel] = []
 // var option: CreateOptionModel?
 
}
struct CreateOptionModel: Identifiable{
    
  var id: String = UUID().uuidString
  var name: String = ""
  var placeHolder = ""
  var optionImageModel:  [OptionImageModel] = []
  var attachments: [String] = []
  var isAnswer: Bool = false
  var isSelected = false
}
struct QuestionImageModel: Identifiable{
    var id: String = UUID().uuidString
    var image:UIImage
    
}

struct OptionImageModel: Identifiable{
    var id: String = UUID().uuidString
    var image:UIImage
    
}
