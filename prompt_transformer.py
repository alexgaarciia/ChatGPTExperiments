import tkinter as tk


class PromptSelector:
    def __init__(self, llm_type):
        self.llm_type = llm_type
        self.training_data = {}

    def add_training_example(self, prompt, expected_result):
        self.training_data[prompt] = expected_result

    def evaluate_prompt(self, prompt):
        return len(prompt)

    def select_best_prompt(self):
        best_prompt = None
        best_score = float('-inf')

        for prompt, expected_result in self.training_data.items():
            score = self.evaluate_prompt(prompt)
            if score > best_score:
                best_score = score
                best_prompt = prompt

        return best_prompt

class PromptSelectorGUI:
    def __init__(self, llm_type):
        self.llm_type = llm_type
        self.prompt_selector = PromptSelector(llm_type)

        # Configuración de la interfaz de usuario
        self.root = tk.Tk()
        self.root.title("Selector de Prompt")

        # Entrada para el nuevo prompt
        self.prompt_entry = tk.Entry(self.root, width=50)
        self.prompt_entry.pack(pady=10)

        # Botón para agregar un nuevo ejemplo de entrenamiento
        self.add_example_button = tk.Button(self.root, text="Agregar Ejemplo", command=self.add_training_example)
        self.add_example_button.pack(pady=5)

        # Botón para seleccionar el mejor prompt
        self.select_prompt_button = tk.Button(self.root, text="Seleccionar Mejor Prompt", command=self.select_best_prompt)
        self.select_prompt_button.pack(pady=10)

        # Etiqueta para mostrar el mejor prompt
        self.best_prompt_label = tk.Label(self.root, text="")
        self.best_prompt_label.pack(pady=10)

    def add_training_example(self):
        prompt = self.prompt_entry.get()
        expected_result = "Resultado esperado"
        self.prompt_selector.add_training_example(prompt, expected_result)
        self.prompt_entry.delete(0, tk.END)

    def select_best_prompt(self):
        best_prompt = self.prompt_selector.select_best_prompt()
        self.best_prompt_label.config(text=f"Mejor prompt para {self.llm_type}: {best_prompt}")

    def run(self):
        self.root.mainloop()


# Ejemplo de Uso
llm_type = "GPT-3"
gui = PromptSelectorGUI(llm_type)
gui.run()
