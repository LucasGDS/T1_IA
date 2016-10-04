local doces = {}

doces.docesapc = {1.1,1.2,1.3,1.4,1.5} -- FATOR DE APRECIACAO DOS 5 DOCES

doces.clareiradif={ -- DIFICULDADE DAS 10 CLAREIRAS
[1]=150,
[2]=140,
[3]=130,
[4]=120,
[5]=110,
[6]=100,
[7]=95,
[8]=90,
[9]=85,
[10]=80
}

doces.distrdoces = {
	[1] = {0,0,0,0,0},
	[2] = {0,0,0,0,0},
	[3] = {0,0,0,0,0},
	[4] = {0,0,0,0,0},
	[5] = {0,0,0,0,0},
	[6] = {0,0,0,0,0},
	[7] = {0,0,0,0,0},
	[8] = {0,0,0,0,0},
	[9] = {0,0,0,0,0},
	[10]= {0,0,0,0,0},
	[11] = {5,5,5,5,5}
}

annealingdistrdoces = {
	[1] = {0,0,0,0,0},
	[2] = {0,0,0,0,0},
	[3] = {0,0,0,0,0},
	[4] = {0,0,0,0,0},
	[5] = {0,0,0,0,0},
	[6] = {0,0,0,0,0},
	[7] = {0,0,0,0,0},
	[8] = {0,0,0,0,0},
	[9] = {0,0,0,0,0},
	[10]= {0,0,0,0,0},
	[11] = {5,5,5,5,5}
}

doces.clareiracusto={150,140,130,120,110,100,95,90,85,80}
annealingclareiracusto={150,140,130,120,110,100,95,90,85,80}

--[[
function doces.updtclareiracusto()
	for i=1,10 do
		doces.clareiracusto[i] = doces.calccusto(i)
	end
end--]]

--funcoes de calcular custo individual das clareiras
function annealingcalccusto(clareira)
	local soma=0
	for i=1, 5 do
		soma = soma + doces.docesapc[i]*annealingdistrdoces[clareira][i]
	end
	annealingclareiracusto[clareira] = doces.clareiradif[clareira]/soma

end
function doces.calccusto(clareira)
	local soma=0
	for i=1, 5 do
		soma = soma + doces.docesapc[i]*doces.distrdoces[clareira][i]
	end
	doces.clareiracusto[clareira] = doces.clareiradif[clareira]/soma

end

--funcoes de calcular custo total da combinacao de doces
function annealingcustototal()
	custotot = 0
	for i,j in ipairs(annealingclareiracusto) do
		custotot = custotot+j
	end
	return custotot
end
function doces.custototal()
	custotot = 0
	for i,j in ipairs(doces.clareiracusto) do
		custotot = custotot+j
	end
	return custotot
end

--Copia tabela de custo -de copied para pasted
function copytablecusto(copied,pasted)
	for i=1, 10 do
		pasted[i] = copied[i]
	end
end

--Copia tabela de distribuicao de doces -de copied para pasted
function copytabledistr(copied,pasted) 
	for i=1, 11 do
		for j=1, 5 do
			pasted[i][j] = copied[i][j]
		end
	end
end

--Funcao de perturbacao
function neighbour()
	copytablecusto(doces.clareiracusto,annealingclareiracusto)
	copytabledistr(doces.distrdoces,annealingdistrdoces) 

	local randc1,randc2,randd,temp
	--math.randomseed(os.time())
	randc1 = love.math.random(1,10)
	print(randc1)
	--math.randomseed(os.time())
	randc2 = love.math.random(1,10)
	print(randc2)
	--math.randomseed(os.time())
	randd=love.math.random(1,5)
	if  annealingdistrdoces[randc1][randd] ~= annealingdistrdoces[randc2][randd]  then
		annealingdistrdoces[randc1][randd] = doces.distrdoces[randc2][randd]
		annealingcalccusto(randc1)
		annealingdistrdoces[randc2][randd] = doces.distrdoces[randc1][randd]
		annealingcalccusto(randc2)
	else
		neighbour()
	end
end

--Probabilidade de chamar perturbacao
function probabilidade(deltaE,T)
	local P
	if deltaE < 0 then
		P=1
	else
		P=0
		P = math.exp( - deltaE / T)
	end
	return P
end

--acha uma distribuicao para os doces
function doces.combinardocesinicial() 
	local doce, clareira, k, deltaE ,rand
	while doces.distrdoces[11][1]+doces.distrdoces[11][2]+doces.distrdoces[11][3]+doces.distrdoces[11][4]+doces.distrdoces[11][5] > 1 do --inves de randomico busca um minimo
		for i=1, 5 do
			if doces.distrdoces[11][i] > 0 then
				doce = i
			end
		end

		clareira = 1
		for i=1, 10 do
			if doces.clareiracusto[i] > doces.clareiracusto[clareira] then
				clareira = i
			end
		end

		doces.distrdoces[11][doce] = doces.distrdoces[11][doce]  - 1
		doces.distrdoces[clareira][doce] = doces.distrdoces[clareira][doce] + 1
		doces.calccusto(clareira)
	end --minimo achado comecam as operacoes para verficar se alterando acha menor
--[[	
	for k=0,1000 do
		neighbour()
		T = doces.custototal()
		deltaE = T - annealingcustototal()
		--math.randomseed(os.time())
		rand = love.math.random()
		if probabilidade(deltaE,T) > rand then
			copytablecusto(annealingclareiracusto,doces.clareiracusto)
			copytabledistr(annealingdistrdoces,doces.distrdoces) 
		end
		print(doces.custototal())
	end
--]]
end

-- --

doces.combinardocesinicial()
--[[
for i,j in pairs(doces.distrdoces) do  --print da distribuicao inicial
	print("clareira",i)
	for k,l in ipairs(j) do
		print(k, l)
	end

end


print(doces.custototal())
--]]
return doces
