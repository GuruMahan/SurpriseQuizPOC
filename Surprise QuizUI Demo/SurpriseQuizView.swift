//
//  ContentView.swift
//  Surprise QuizUI Demo
//
//  Created by Guru Mahan on 19/01/23.
//

import SwiftUI

struct SurpriseQuizView: View {
    @ObservedObject var viewModel = SurpriseQuizVM()
    @State var headerBGImage = UIImage(named: "HDBGImg")
    @State var image = UIImage(named: "optionDots")
    @State var nameTxtField = ""
    @State var showSetKeyView = false
    @State var showAlert = false
    var callBackOption:(CreateOptionModel)->() = { _ in }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color(hex:  "#FFDCDCDC").opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea()
                VStack {
                    Color(hex:"#53AEF9")
                        .frame(height: UIScreen.main.safeAreaInsets.top)
                    Spacer()
                }
                VStack {
                    VStack(spacing: 0) {
                        headerView
                            .frame(height: 50)
                            .background(Color.blue)
                        questionTitleView
                            .frame(height: 70)
                        ScrollView {
                            VStack {
                                QuestionView(viewModel: viewModel)
                                Button {
                                    withAnimation {
                                        if viewModel.questionsList.count <= 1 {
                                            viewModel.addNewQuestion()
                                        }
                                    }
                                } label: {
                                    HStack{
                                        Text(" + Add New question")
                                            .foregroundColor(.black)
                                    }
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(  Color(hex: "#E1F5FA"))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                        bottomView
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, UIScreen.main.safeAreaInsets.top)
                if viewModel.setAnsWerKeyPopUPView , let key = viewModel.setKeyQuestion?.wrappedValue {
                    setAnswerKeyView(answerKey: key, isShowing: $viewModel.setAnsWerKeyPopUPView) { model in
                        viewModel.popViewchangeOption(question: model)
                        viewModel.callBackData(question: model)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    @ViewBuilder var headerView:some View {
        ZStack {
            if let img = headerBGImage {
                Image(uiImage: img)
                    .resizable()
                
                    .frame(maxWidth: .infinity,maxHeight: 70)
            }
            HStack {
                HStack(spacing: 16) {
                    Button {
                    } label: {
                        Image(systemName:"arrow.backward")
                            .foregroundColor(.white)
                    }
                    Text("Surprise Quiz")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(Font.system(size: 20))
                    Spacer()
                }
                .padding()
                Spacer()
                HStack {
                    Button  {
                    } label: {
                        if let img = image {
                            Image(uiImage: img)
                                .foregroundColor(.white)
                        }
                    }
                    
                }
            }
            .padding(.trailing)
        }
    }
    
    @ViewBuilder var questionTitleView: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Quiz Title")
                    .font(Font.system(size: 12))
                    .padding(.top,10)
                TextField("Name01", text: $nameTxtField )
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 6))
                    .frame(maxWidth: 310,maxHeight: 40)
                    .overlay(                                        RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray,lineWidth: 1))
                    .padding(10)
            }
            .padding(.leading)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
    
    //MARK: -> bottomView
    @ViewBuilder var bottomView: some View {
        ZStack {
            Color.white
                .shadow(
                    color: Color.gray.opacity(0.7),
                    radius: 5,
                    x: -8,
                    y: 0
                )
            HStack(spacing: 30) {
                Button {
                    showAlert = true
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity )
                        .frame(height: 40)
                        .foregroundColor(.blue)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.blue, lineWidth: 2))
                }
                .padding(.leading)
                .alert("Are you sure want to Exit This Screen", isPresented: $showAlert) {
                    Button("Yes", role: .cancel) { }
                }
                Button {
                } label: {
                    Text("Save")
                        .fontWeight(.bold)
                        .frame(height: 40)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.trailing)
            }
            .padding(.bottom,5)
        }
        .frame(maxWidth: .infinity)
        .frame( height: 60)
    }
}

//MARK: -> Struct QuestionView
struct QuestionView: View {
    @ObservedObject var viewModel : SurpriseQuizVM
    var removeOption: ((Int) -> Void)?
    @State var holderImage = UIImage(named: "holderImage")
    @State var xmarkImg = UIImage(named: "xmarkImg")
    @State var CopyImg = UIImage(named: "CopyImg")
    @State var DeleteImg = UIImage(named: "DeleteImg")
    @State var questionTextImage = UIImage(named: "")
    @State var optionTextImage = UIImage(named: "")
    @State var selectedImage = false
    @State var selectedOptionImage = false
    
    //MARK: -> QuestionbodyView
    var body: some View {
        ZStack {
            VStack {
                ForEach($viewModel.questionsList, id: \.id) { question in
                    HStack(spacing: 0) {
                        ZStack{
                            Color(hex: "#3799ED")
                            HStack {
                                questionBlueSideView
                                    .frame(width: 2)
                                //.background(Color.blue)
                                questionsView(question: question )
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                            }
                        }
                    }
                    .padding(5)
                }
                .cornerRadius(30)
            }
        }
        .sheet(isPresented: $selectedImage) {
            PhotoPicker(sourceTYPE: .photoLibrary) { image in
                if let index = viewModel.questionIndex{
                    viewModel.questionsList[index].questionImageModel.append(QuestionImageModel(image: image))
                }
            }
        }
        .sheet(isPresented: $selectedOptionImage) {
            PhotoPicker(sourceTYPE: .photoLibrary) { image in
                if let index = viewModel.optionIndex, let index1 = viewModel.questionIndex{
                    viewModel.questionsList[index1].options[index].optionImageModel.append(OptionImageModel(image: image))
                }
            }
        }
    }
    
    //MARK: ->questionsView
    @ViewBuilder func questionsView(question: Binding<CreateQuestionModel>) -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack{
                    TextField("\((viewModel.indexOf(question: question.wrappedValue ) ?? 0) + 1 ).question", text: question.text)
                        .padding()
                    Spacer()
                    Button {
                        viewModel.questionIndex =   viewModel.indexOf(question: question.wrappedValue)
                        selectedImage = true
                    } label: {
                        if let img = holderImage{
                            Image(uiImage: img)
                                .padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#838383").opacity(0.2))
                .cornerRadius(10, corners: [.topLeft,.topRight])
                .padding(5)
                if !question.questionImageModel.wrappedValue.isEmpty {
                    VStack{
                        ForEach(0..<(question.wrappedValue.questionImageModel.count),id: \.self){ index in
                            HStack(spacing: 10){
                                if let img = question.wrappedValue.questionImageModel[index].image {
                                    Image(uiImage:img)
                                        .resizable()
                                        .frame(width: 80,height: 80)
                                        .cornerRadius(20, corners: .allCorners)
                                }
                                Spacer()
                                Button {
                                    withAnimation {
                                        question.questionImageModel.wrappedValue.removeAll(where: { $0.id == question.wrappedValue.questionImageModel[index].id})
                                    }
                                } label: {
                                    if let img = xmarkImg{
                                        Image(uiImage: img)
                                            .resizable()
                                            .foregroundColor(.black)
                                            .frame(width: 14,height: 14)
                                    }
                                }
                            }.padding(.trailing,25)
                        }
                    }
                }
                Divider()
            }
            optionView(question: question)
            Spacer()
        }
    }
    
    //MARK: -> questionBlueSideView
    @ViewBuilder var questionBlueSideView: some View {
        ZStack {
        }
        .background(Color(hex: "#3799ED"))
    }
    
    //MARK: -> optionView
    @ViewBuilder func optionView(question: Binding<CreateQuestionModel>) -> some View {
        VStack {
            VStack(alignment:.leading,spacing: 2) {
                ForEach(question.options, id: \.id) { option1 in
                    let option = option1.wrappedValue
                    HStack {
                        Button {
                            viewModel.changeOption(question: question.wrappedValue, option: option)
                            // viewModel.optionSelected = option
                        } label: {
                            Image(systemName: option.isSelected  ?  "largecircle.fill.circle" : "circle")
                                .foregroundColor(option.isSelected ? .green : .black)
                        }
                        TextField("option-\((viewModel.optionIndexOf(question: question.wrappedValue, option: option) ?? 0) + 1)", text: option1.name)
                        Spacer()
                        Button {
                            viewModel.questionIndex = viewModel.indexOf(question: question.wrappedValue)
                            viewModel.optionIndex =   viewModel.optionIndexOf(question: question.wrappedValue, option: option)
                            selectedOptionImage = true
                        } label: {
                            if let img = holderImage {
                                Image(uiImage: img)
                            }
                        }
                        Button {
                            withAnimation {
                                question.options.wrappedValue.removeAll(where: {$0.id == option1.id.wrappedValue})
                            }
                        } label: {
                            if let img = xmarkImg{
                                Image(uiImage: img)
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 14,height: 14)
                            }
                        }
                    }
                    .padding()
                    if let index = viewModel.optionIndexOf(question: question.wrappedValue, option: option) {
                        VStack{
                            if  !question.wrappedValue.options[index].optionImageModel.isEmpty {
                                ForEach(0..<(question.wrappedValue.options[index].optionImageModel.count),id: \.self){ index2 in
                                    HStack(spacing: 10){
                                        if let img = question.wrappedValue.options[index].optionImageModel[index2].image{
                                            Image(uiImage:img)
                                                .resizable()
                                                .frame(width: 80,height: 80)
                                                .cornerRadius(20, corners: .allCorners)
                                        }
                                        Spacer()
                                        Button {
                                            withAnimation {
                                                question.wrappedValue.options[index].optionImageModel.removeAll(where: { $0.id == question.wrappedValue.options[index].optionImageModel[index2].id})
                                            }
                                        } label: {
                                            if let img = xmarkImg{
                                                Image(uiImage: img)
                                                    .resizable()
                                                    .foregroundColor(.black)
                                                    .frame(width: 14,height: 14)
                                            }
                                        }
                                    }.padding(.trailing,25)
                                }
                            }
                        }
                        
                    }
                }
                HStack(spacing: 2) {
                    Button {
                        withAnimation {
                            viewModel.addNewOption(question: question.wrappedValue)
                        }
                    } label: {
                        Image(systemName: "plus")
                        Text("Add Option")
                    }
                    .disabled( question.wrappedValue.options.count >= 4)
                    .padding(.leading,8)
                    .font(.system(size: 15))
                    .padding(.trailing,8)
                }
                .frame(height: 35)
                .background(Color(hex: "#EDF6FF"))
                .cornerRadius(20)
                .padding(10)
                Divider()
                setAnswerKeyoptionView(question: question)
                    .padding()
            }
        }
    }
    
    //MARK: -> setAnswerKeyoptionView
    @ViewBuilder func setAnswerKeyoptionView(question: Binding<CreateQuestionModel>) -> some View{
        HStack(spacing: 20){
            Button {
                if
                    CheckQusAndOptionText(question: question.wrappedValue) {
                    viewModel.setKeyQuestion = question
                    viewModel.setAnsWerKeyPopUPView = true
                }
            } label: {
                Text("Set Answer Key")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
            Spacer()
            Button {
                withAnimation {
                    if viewModel.questionsList.count <= 1{
                        viewModel.addNewQuestion()
                    }
                }
            } label: {
                
                Image(systemName: "plus")
            }
            Button {
                if viewModel.questionsList.count <= 1{
                    copyQuestionCell(question: question.wrappedValue)
                }
            } label: {
                if let img = CopyImg{
                    Image(uiImage: img)
                }
            }
            Button {
                withAnimation {
                    if let index = viewModel.questionsList.lastIndex(where: { $0.id == question.wrappedValue.id }) {
                        viewModel.removeNewQuestion(question: question.wrappedValue, index: index)
                    }
                }
            } label: {
                if let img = DeleteImg{
                    Image(uiImage: img)
                }
            }
        }
    }
    
    func CheckQusAndOptionText(question: CreateQuestionModel) -> Bool {
        var flag = true
        question.options.forEach { option in
            if option.name.isEmpty {
                flag = false
            }
        }
        if question.options.count < 2 {
            flag = false
        }
        return flag
    }
    
    func copyQuestionCell(question: CreateQuestionModel) {
        if !question.text.isEmpty, let index = viewModel.indexOf(question: question){
            var newQuestion = question
            newQuestion.id = UUID().uuidString
            viewModel.questionsList.insert(newQuestion, at: index + 1)
        }
    }
    
    //MARK: -> optionSelectedImageView
    @ViewBuilder var optionSelectedImageView: some View {
        if optionTextImage != nil{
            HStack(spacing: 10){
                if let img = optionTextImage{
                    Image(uiImage:img)
                        .resizable()
                        .frame(width: 80,height: 80)
                        .cornerRadius(20, corners: .allCorners)
                }
                Spacer()
            }.padding(5)
        }
    }
}

struct setAnswerKeyView: View {
    @State var answerKey:CreateQuestionModel?
    @Binding var isShowing: Bool
    @State var reload:Bool = false
    var setOptionkeyAnswer:((CreateQuestionModel)->())?
    var body: some View {
        ZStack(alignment: .bottom){
            if let ans = answerKey {
                withAnimation {
                    setAnsWerKeyPopUPView(question: ans  )
                }
            }
            if reload {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
        .ignoresSafeArea()
        .transition(.move(edge: .bottom))
    }
    
    @ViewBuilder   func setAnsWerKeyPopUPView(question: CreateQuestionModel) -> some View {
        ZStack(alignment: .bottom) {
            if isShowing{
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
            }
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment:.leading,spacing: 2) {
                        ForEach(question.options, id: \.id) { option1 in
                            let option = option1
                            HStack{
                                Button {
                                    popUpViewchangeOption(option: option)
                                } label: {
                                    Image(systemName: option.isAnswer  ?  "largecircle.fill.circle" : "circle")
                                        .foregroundColor(option.isAnswer ? .green : .black)
                                }
                                Text("\(option1.name)")
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    Button {
                        if let ans = answerKey {
                            setOptionkeyAnswer?(ans)
                        }
                        isShowing = false
                    } label: {
                        Text("SetKey")
                            .font(.headline)
                            .font(.system(size: 20))
                    }
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue,lineWidth: 1).frame(width: 70,height: 40))
                    .padding(5)
                }
                .padding()
                Spacer()
            }.frame(height: 400)
                .frame(maxWidth: .infinity)
                .background(Color.white)
        }
        .animation(.easeInOut)
    }
    
    func popUpViewchangeOption(option: CreateOptionModel) {
        if let answer = answerKey?.options.enumerated() {
            for (indexI,model) in answer {
                if model.id == option.id {
                    answerKey?.options[indexI].isAnswer = true
                    
                } else {
                    answerKey?.options[indexI].isAnswer = false
                }
            }
        }
    }
    
    func optionIndexOf(option:CreateOptionModel) -> Int? {
        answerKey?.options.lastIndex(where: {$0.id == option.id})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SurpriseQuizView()
    }
}
