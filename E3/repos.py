import random as r

fcat = open("raw data/categorias.raw", "r")
fcat_s = open("raw data/categorias_simples.raw", "r")
fcat_S = open("raw data/super_categorias.raw", "r")
ft_outra = open("raw data/tem_outra.raw", "r")
fprod = open("raw data/produtos.raw", "r")
fivm = open("raw data/ivm.raw", "r")
fresp = open("raw data/responsavel_por.raw", "r")
fprat_out = open("pop_prateleiras.sql", "w")
fplan_out = open("pop_planogramas.sql", "w")
frepo_out = open("pop_reposicoes.sql", "w")

categorias = fcat.read().splitlines()
categorias_simples = fcat_s.read().splitlines()
super_categorias = fcat_S.read().splitlines()
tem_outra = []
lines = ft_outra.readlines()
for line in lines:
    line = line[:-1]
    tem_outra.append(line.split(','))
produtos = []
lines = fprod.readlines()
for line in lines:
    line = line[:-1]
    produtos.append(line.split(','))
ivm = []
lines = fivm.readlines()
for line in lines:
    line = line[:-1]
    ivm.append(line.split(','))
responsavel_por = dict()
lines = fresp.readlines()
for line in lines:
    line = line[:-1]
    inst_line = line.split(',')
    #print(inst_line)
    responsavel_por[inst_line[0]] = [inst_line[1], inst_line[2]]
# prateleira(num_prateleira, num_serie, fabricante, altura, categoria_simples_nome)
prateleira = []
for inst_ivm in ivm:
    for i in range(1,6):
        cat = r.choice(categorias_simples)
        alt = r.randint(10, 20)
        prateleira.append([i, inst_ivm[0], inst_ivm[1], alt, cat])
for inst in prateleira:
    print("insert into prateleira values ({},{},'{}',{},'{}');".format(inst[0], inst[1], inst[2], inst[3], inst[4]), file=fprat_out)

# planograma(ean, num_prateleira, num_serie, fabricante, faces, unidades, loc)
planograma = []
for inst_prateleira in prateleira:
    faces = r.randint(1, 5)
    unidades = r.randint(faces*4, faces*7)
    loc = "Fila " + str(r.randint(1, faces))
    produto = r.choice(produtos)
    while produto[1] != inst_prateleira[4]:
        produto = r.choice(produtos)
    planograma.append([produto[0], inst_prateleira[0], inst_prateleira[1], inst_prateleira[2], faces, unidades, loc])
for inst in planograma:
    print("insert into planograma values ({}, {}, {}, '{}', {}, {}, '{}');".format(inst[0], inst[1], inst[2], inst[3], inst[4], inst[5], inst[6]), file=fplan_out)

# evento_reposicao(ean, num_prateleira, num_serie, fabricante, instante, unidades, tin)
evento_reposicao = []
for i in range(1, 6):
    for inst_ret in responsavel_por.keys():
        #print(inst_ret)
        for inst_plan in planograma:
            if inst_plan[2]!=responsavel_por[inst_ret][0] or inst_plan[3]!=responsavel_por[inst_ret][1]:
                continue
            if r.random() > 0.9:
                continue
            ano = r.randint(2022,2023)
            mes = r.randint(1, 12)
            dia = r.randint(1,15)
            hora = r.randint(12, 18)
            minuto = r.randint(1,59)
            segundo = r.randint(1,59)
            timestamp = str(ano) + '-' + "%02d"% mes + "-" + "%02d"%dia + " " + str(hora) + ":" + "%02d"%minuto + ":" + "%02d"%segundo
            unidades = r.randint(1, inst_plan[5])
            evento_reposicao.append([inst_plan[0], inst_plan[1], inst_plan[2], inst_plan[3], timestamp, unidades, inst_ret])
for inst in evento_reposicao:
    print("insert into evento_reposicao values ({}, {}, {}, '{}', '{}', {}, {});".format(inst[0], inst[1], inst[2], inst[3], inst[4], inst[5], inst[6]), file=frepo_out)
#print("ean, num_prateleira, num_serie, fabricante, instante, unidades, tin")
#for inst in evento_reposicao:
#    print(inst)
#print(responsavel_por)
fprat_out.close()
fplan_out.close()
frepo_out.close()