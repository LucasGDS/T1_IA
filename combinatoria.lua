local docesclareira={}
local docesapc={}
local distrdoces = {}
local custotot

docesapc = {1.1,1.2,1.3,1.4,1.5}

distrdoces = {
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
	cesta = {5,5,5,5,5}
}

clareiradif={
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
clareiracusto={150,140,130,120,110,100,95,90,85,80}

function updtclareiracusto()
	for i=1,10 do
		clareiracusto[i] = calccusto(i)
	end
end

function calccusto(clareira)
	local soma=0
	for i=1, 5 do
		soma = soma + docesapc[i]*distrdoces[clareira][i]
	end
	clareiracusto[clareira] = clareiradif[clareira]/soma

end

function custototal()
	custotot = 0
	for i,j in ipairs(clareiracusto) do
		custotot = custotot+j
	end
end

function combinardocesinicial() --acha uma distribuicao inicial
	local doce, clareira
	while distrdoces.cesta[1]+distrdoces.cesta[2]+distrdoces.cesta[3]+distrdoces.cesta[4]+distrdoces.cesta[5] > 1 do
		for i=1, 5 do
			if distrdoces.cesta[i] > 0 then
				doce = i
			end
		end

		clareira = 1
		for i=1, 10 do
			if clareiracusto[i] > clareiracusto[clareira] then
				clareira = i
			end
		end

		distrdoces.cesta[doce] = distrdoces.cesta[doce]  - 1
		distrdoces[clareira][doce] = distrdoces[clareira][doce] + 1
		calccusto(clareira)
	end
end

--[[  ]]

combinardocesinicial() 

for i,j in pairs(distrdoces) do  --print da distribuicao inicial
	print("clareira",i)
	for k,l in ipairs(j) do
		print(k, l)
	end

end


custototal()
print(custotot)
