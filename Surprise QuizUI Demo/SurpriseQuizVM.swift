//
//  SurpriseQuizVM.swift
//  Surprise QuizUI Demo
//
//  Created by Guru Mahan on 19/01/23.
//

import Foundation
import SwiftUI

class SurpriseQuizVM: ObservableObject {
    @Published var setKeyQuestion: Binding<CreateQuestionModel>?
    @Published var questionsList: [CreateQuestionModel] = []
    @Published var questionsSelected: CreateQuestionModel?
    @Published var optionSelected: CreateOptionModel?
    @Published var questionIndex: Int?
    @Published var optionIndex: Int?
    @Published var selectedIndex: Int = 0
    @Published var setAnsWerKeyPopUPView = false
    @Published var answerKey:CreateQuestionModel?
   // @Published var optionTextfielf = ["guru","guru"]
    init() {
        questionsList.append(createNewQuestion(index: questionCount))

    }
    
    var questionCount: Int {
        questionsList.count
    }
    
    func createNewQuestion(index: Int) ->CreateQuestionModel {
        
        var question =  createQuestion(text: "", placeHolder: "Question", option: CreateOptionModel(),  optionPlaceHolder: "option-1", optionId: "0")
        for _ in 1..<2{
          
            question.options.append(CreateOptionModel())
            
        }
        return question
        
    }
   
   
    func createQuestion(text:String,placeHolder:String,option:CreateOptionModel,optionPlaceHolder:String,optionId:String) -> CreateQuestionModel{
       
        var question = CreateQuestionModel()
        question.text = text
        question.placeHolder = placeHolder
       
        
        var option1 = option
        option1.placeHolder = optionPlaceHolder
        question.options.append(option1)
        return question
    }
    
    
    func optionIndexOf(question: CreateQuestionModel,option:CreateOptionModel) -> Int? {
        if let index =  questionsList.lastIndex(where: { $0.id == question.id }){
            return questionsList[index].options.lastIndex(where: {$0.id == option.id})
        }
      //  questionsList[index].options.lastIndex(where: {$0.id == option.id})
     return nil
    }
    func indexOf(option: CreateOptionModel) -> Int? {
        questionsList.lastIndex(where: { $0.id == option.id })
    }
    
    func indexOf(question: CreateQuestionModel) -> Int? {
        questionsList.lastIndex(where: { $0.id == question.id })
    }
    func removeNewQuestion(question:CreateQuestionModel,  index: Int) {
        if let index = questionsList.lastIndex(where: { $0.id == question.id }) {
            questionsList.remove(at: index)
        }
     
    }
    func delete(at offsets: IndexSet){
        
        var question = CreateQuestionModel()
        question.options.remove(atOffsets: offsets)
    }
   
    func addNewQuestion() {
        questionsList.append(createNewQuestion(index: questionCount))
        
    }

    func insertNewQuestion(question: CreateQuestionModel) {
        
        if let index = questionsList.lastIndex(where: { $0.id == question.id }) {
            questionsList.insert(createNewQuestion(index: index+1), at: index+1)
        }
        
    }
    
//    func removeQuestion(question: CreateQuestionModel,option: CreateOptionModel) {
//        if let indexO = questionsList.lastIndex(where: { $0.id == question.id }) {
//
//            for (indexI,model) in questionsList[indexO].options.enumerated(){
//                if model.id == option.id {
//                    questionsList[indexO].options[indexI].isSelected = true
//                } else {
//                    questionsList[indexO].options[indexI].isSelected = false
//                }
//            }
//        }
//    }
//    
    func addNewOption(question: CreateQuestionModel) {

        if let index = questionsList.lastIndex(where: { $0.id == question.id }) {
            return  questionsList[index].options.append(CreateOptionModel( placeHolder: "Option-\(index+1)"))
    
        }
        
    }
    func popUpViewchangeOption(question: CreateQuestionModel, option: CreateOptionModel) {
        
        if let indexO = questionsList.lastIndex(where: { $0.id ==  question.id }) {
            
            for (indexI,model) in questionsList[indexO].options.enumerated() {
                if model.id == option.id {
                    questionsList[indexO].options[indexI].isAnswer = true
                } else {
                    questionsList[indexO].options[indexI].isAnswer = false
                }
            }
        }
    }

    func popViewchangeOption(question: CreateQuestionModel) {
        
        if let indexO = questionsList.lastIndex(where: { $0.id ==  question.id }) {
            
            for (indexI,model) in question.options.enumerated() {
                questionsList[indexO].options[indexI].isAnswer = model.isAnswer
            }
        }
    }
  
    func callBackData(question: CreateQuestionModel) {
        
        if let indexO = questionsList.lastIndex(where: { $0.id ==  question.id }) {
            
            for (indexI,model) in question.options.enumerated() {
                questionsList[indexO].options[indexI].isSelected = model.isAnswer
            }
        }
    }
    
    func changeOption(question: CreateQuestionModel, option: CreateOptionModel) {
        
        if let indexO = questionsList.lastIndex(where: { $0.id ==  question.id }) {
            
            for (indexI,model) in questionsList[indexO].options.enumerated() {
                if model.id == option.id {
                    questionsList[indexO].options[indexI].isSelected = true
                } else {
                    questionsList[indexO].options[indexI].isSelected = false
                }
            }
        }
    }
}
