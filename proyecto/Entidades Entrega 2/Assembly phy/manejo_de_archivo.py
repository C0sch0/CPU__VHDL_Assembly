def separar(lineas):
    dicc = {}
    code = 0
    datos_data = []
    datos_code = []
    datos = [lines.strip().split("//")[0] for lines in lineas]
    for dato in datos:
        if dato:


            """if len(dato.split(" "))==1:
                aux = dato.split(" ")[0]
            else:
                aux = dato.split(" ")[0] + " " + dato.split(" ")[1]"""


            if "CODE" in dato:
                code = 1
            elif code == 0 and "DATA" not in dato:
                datos_data.append(dato)
            elif code == 1:
                datos_code.append(dato)

    dicc["DATA"] = datos_data
    dicc["CODE"] = datos_code
    return dicc

def manejo_data(data):
    dicc = {}
    variables = [var.split(" ")[0] for var in data]
    valores = [var.split(" ")[1] for var in data]
    for i in variables:
        dicc[i] = ['{:012b}'.format(variables.index(i))]
    for i in valores:
        if i[-1] == 'd':  # string decimal a binario
            dicc[variables[valores.index(i)]].append('{:016b}'.format(int(i[:-1])))
        elif i[-1] == 'b':  # string binario a binario
            dicc[variables[valores.index(i)]].append('{:016b}'.format(int(i[:-1], 2)))
        elif i[-1] == 'h':  # string hexa a binario
            dicc[variables[valores.index(i)]].append('{:016b}'.format(int(i[:-1], 16)))
        else:
            dicc[variables[valores.index(i)]].append('{:016b}'.format(int(i)))
    return dicc
