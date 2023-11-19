# Import tkinter library (standard GUI toolkit)
import tkinter as tk


class PromptSelector:
    def __init__(self):
        self.llm_type = ""

        # Create the main window of the GUI:
        self.tkwindow = tk.Tk()

        # Include a dropdown to select the model:
        models = ["ChatGPT", "Bard", "Mistral", "LLaMA"]
        self.model_var = tk.StringVar(self.tkwindow)
        self.model_var.set(models[0])
        self.model_dropdown = tk.OptionMenu(self.tkwindow, self.model_var, *models)
        self.model_dropdown.pack(pady=10)

        # Prompt input:
        self.prompt_entry = tk.Entry(self.tkwindow, width=50)
        self.prompt_entry.pack(pady=5)

        # Button to obtain the best prompt for the chosen model:
        self.select_prompt_button = tk.Button(self.tkwindow, text="Obtain best prompt", command=self.select_best_prompt)
        self.select_prompt_button.pack(pady=10)

        # Label for showing the best prompt:
        self.best_prompt_label = tk.Label(self.tkwindow, text="")
        self.best_prompt_label.pack(pady=10)

    def select_best_prompt(self):
        """This is a function that returns the best prompt"""
        prompt = self.prompt_entry.get()
        llm_type = self.model_var.get()
        formatted_prompt = self.format_prompt(llm_type, prompt)
        self.best_prompt_label.config(text=f"Best prompt for {llm_type}:\n{formatted_prompt}")

    def format_prompt(self, llm_type, prompt):
        """This is a function that chooses the best format depending on the llm_type"""
        if llm_type == "ChatGPT":
            return f"ChatGPT Prompt: ### {prompt} ###"
        elif llm_type == "Bard":
            return f"Bard Prompt: ### {prompt} ###"
        elif llm_type == "Mistral":
            return f"Mistral Prompt: [INST] {prompt} [/INST]"
        elif llm_type == "LLaMA":
            return f"LLaMA Prompt: [INST] {prompt} [/INST]"

    def run(self):
        self.tkwindow.mainloop()


example = PromptSelector()
example.run()
