class Linter:
    def __init__(self, code):
        self.code = code
        self.errors = []

    def check_indentation(self):
        lines = self.code.split('\n')
        for i, line in enumerate(lines):
            if len(line) - len(line.lstrip()) % 4 != 0:
                self.errors.append(f'Indentation error at line {i+1}')

    def check_syntax(self):
        try:
            compile(self.code, '', 'exec')
        except SyntaxError as e:
            self.errors.append(f'Syntax error at line {e.lineno}: {e.msg}')

    def check_variable_names(self):
        lines = self.code.split('\n')
        for i, line in enumerate(lines):
            if ' = ' in line:
                var_name = line.split(' = ')[0].strip()
                if not var_name.islower() or not var_name.replace('_', '').isalpha():
                    self.errors.append(f'Invalid variable name at line {i+1}: {var_name}')

    def check_function_names(self):
        lines = self.code.split('\n')
        for i, line in enumerate(lines):
            if 'def ' in line:
                func_name = line.split('def ')[1].split('(')[0].strip()
                if not func_name.islower() or not func_name.replace('_', '').isalpha():
                    self.errors.append(f'Invalid function name at line {i+1}: {func_name}')

    def run(self):
        self.check_indentation()
        self.check_syntax()
        self.check_variable_names()
        self.check_function_names()
        return self.errors

def main():
    code = '''
x = 5
y = 10
def add(a, b):
    return a + b
print(add(x, y))
'''
    linter = Linter(code)
    errors = linter.run()
    for error in errors:
        print(error)

if __name__ == '__main__':
    main()