import re
import sys
from manejo_de_archivo import separar, manejo_data
import json

class Assembly():
    def __init__(self, info_dict, path):
        self.data = info_dict['DATA']
        self.code = info_dict['CODE']
        self.instructions = list()
        self.opcodes = dict()
        self.opcodes = self.get_opcodes()
        self.start_assembly()
        self.fin = list()

    def start_assembly(self):
        for operation in self.code:
            instruction, values = operation.split(" ")
            ##PENDIENTE
            if instruction == "JMP":
                pass

            else:
                valA, valB = values.split(",")
                results = self.get_var_type(valA, valB)
                operation = operation.replace(valA, results[0][0])
                operation = operation.replace(valB, results[1][0])
                search_for = instruction + " " + operation

                if search_for in self.opcodes:
                    opcde = self.opcodes[search_for].zfill(17)
                    self.fin.append(results[1] + opcde)

        print(self.fin)

    def get_opcodes(self, path):
        with open(path) as file:
            return json.load(file)

    def get_var_type(self, valA, valB):
        vals = []
        if valA == "A":
            vals.append(("A", "0".zfill(16)))

        elif "(" in valA:
            valb = self.get_values(valA[1:-1])
            vals.append(("(DIR)", valb))

        else:
            valb = self.get_values(valA)
            vals.append(("LIT", valb))

        if valB == "B":
            vals.append(("B", "0".zfill(16)))

        elif "(" in valB:
            valb = self.get_values(valB[1:-1])
            vals.append(("(DIR)", valb))

        else:
            valb = self.get_values(valB)
            vals.append(("LIT", valb))

        return vals


    def get_instruction(self):
        pass

    @staticmethod
    def get_values(value):
        return (bin(value))[2:].zfill(16)


def variables(codigo):
    instrucciones = []
    with open("opcodes_dict.json") as opcodes_dict:
        opcodes = json.load(opcodes_dict)
        for value in codigo.values():
            instrucciones.append(value[1].zfill(16) + (opcodes["MOV B,Lit"][0].zfill(17)))
            instrucciones.append(value[0].zfill(16) + (opcodes["MOV (DIR),B"][0].zfill(17)))
        instrucciones.append("0000000000000000" + (opcodes["MOV (DIR),B"][0].zfill(17)))
    return instrucciones


def labels_(all_code):
    data = all_code['DATA']
    code = all_code['CODE']
    labels = {}
    linea = len(code['DATA'])
    for i in code:
        if ":" in i:
            i = i[:-1]
            labels[i] =  bin(linea)[2:].zfill(16)
        linea += 1
    return labels



if __name__ == '__main__':
    with open('assembly.txt', 'r') as file:
        lineas = file.readlines()
        dict_datos = separar(lineas)
        instrucc = manejo_data(dict_datos["DATA"])
        dict_datos["DATA"] = instrucc
        with open("instruction_memory.txt", "w") as output:
            pass




