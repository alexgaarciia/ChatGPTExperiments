def zeroshot_to_zeroshotcot(input_sentence):
    # Find the index of the first occurrence of "Question:"
    question_index = input_sentence.find("Question:")

    # Extract the substring from the index of "Question:" to the end
    transformed_sentence = input_sentence[question_index:].strip()

    # Remove "Question:" and "Answer:" and add "Let's think step by step"
    transformed_sentence = transformed_sentence.replace("Question:", "").replace("Answer:", "").strip()
    transformed_sentence += "\n\nLet's think step by step"

    return transformed_sentence


# Example usage
input_sentence = str(input("Please enter a sentence to transform from Zero-Shot to Zero-Shot COT:\n"))
result_sentence = zeroshot_to_zeroshotcot(input_sentence)
print(result_sentence)
