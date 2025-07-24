//
//  CreateRecipeView.swift
//  App
//
//  Created by krnklvx on 22.07.2025.
//

import SwiftUI

struct CreateRecipeView: View {
    @Binding var recipes: [Recipe] //привязка к массиву рецептов, позволяет менять родительский массив
    @Environment(\.dismiss) var dismiss //метод для закрытия экрана по кнопке готово
    
    @State private var name = ""
    @State private var ingredients = ""
    @State private var amounts = "" // Для количеств
    @State private var steps = ""
    @State private var time = ""
    @State private var calories = ""

    var body: some View {
        NavigationStack {
            Form { //контейнер для создания форм ввода данных
                Section { //разделяет форму на логические секции
                    TextField("Название рецепта*", text: $name) //текстовое поле для ввода
                    TextField("Ингредиенты (через запятую)", text: $ingredients)
                    TextField("Количества (через запятую)", text: $amounts)
                    TextField("Время (мин)*", text: $time)
                    TextField("Калории", text: $calories)
                }
                .listRowBackground(Color("GlamourPink").opacity(0.1))
                
                Section {
                    Text("Шаги приготовления")
                        .font(.headline)
                        .foregroundColor(Color("GlamourPink"))
                    TextEditor(text: $steps)
                        .frame(height: 150)
                }
            }
            .navigationTitle("💅Новый рецепт💅")
            .foregroundColor(Color("GlamourPink")) // Основной цвет текста
            
            .toolbar { //навигационная панель
                Button("Готово") {
                    // Проверяем обязательные поля перед сохранением
                    if !name.isEmpty && !time.isEmpty {
                        let ingredientsArray = zip(
                            ingredients.components(separatedBy: ","), //разбиение строки пользователя по запятой
                            amounts.components(separatedBy: ",")
                        ).map { //создаем пару ингредиент - значение кол-ва, если массивы разных размеров то лишнее отбрасывается
                            Ingredient(
                                name: $0.trimmingCharacters(in: .whitespaces), //$0- первый параметр,убираем лишние пробелы и переносы строк
                                amountPerServing: Double($1.trimmingCharacters(in: .whitespaces)) ?? 0,//если не удалось конвертировать nil
                                unit: "г" // Просто ставим "г" по умолчанию
                            )
                        }
                        
                        let newRecipe = Recipe(
                            name: name,
                            imageName: "recipe_placeholder",
                            calories: Int(calories) ?? 0, //преобразует в инт
                            time: Int(time) ?? 0,
                            ingredients: ingredientsArray, //передаем массив созданный в зипе
                            steps: steps.components(separatedBy: "\n") //делим по переносу строки
                        )
                        
                        recipes.append(newRecipe) //это массив binding автомат изменяет родительскую вьюшку
                        dismiss() //закрывает текущее окно и возвращает к предыдущему
                    }
                }
                .foregroundColor(name.isEmpty || time.isEmpty ? .gray : Color("GlamourPink")) // Серый, если не все заполнено
            }
        }
    }
}

