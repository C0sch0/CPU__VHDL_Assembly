import json

def variables(codigo):
    instrucciones = []
    with open("opcodes_dict.json") as opcodes_dict:
        opcodes = json.load(opcodes_dict)
        for value in codigo.values():
            instrucciones.append(value[1].zfill(16) + (opcodes["MOV B,Lit"][0].zfill(17)))
            instrucciones.append(value[0].zfill(16) + (opcodes["MOV (DIR),B"][0].zfill(17)))
        instrucciones.append("0000000000000000" + (opcodes["MOV (DIR),B"][0].zfill(17)))
    return instrucciones
print(variables({'v1': ('000000000000', '0000000000001010'), 'v2': ('000000000001', '0000000000000001')}))