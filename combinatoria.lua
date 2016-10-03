doces = {}
local docesclareira={}
local docesapc={}
local distrdoces = {}
local custotot

doces.docesapc = {1.1,1.2,1.3,1.4,1.5}

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

doces.clareiradif={
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
doces.clareiracusto={150,140,130,120,110,100,95,90,85,80}

function doces.updtclareiracusto()
	for i=1,10 do
		doces.clareiracusto[i] = doces.calccusto(i)
	end
end

function doces.calccusto(clareira)
	local soma=0
	for i=1, 5 do
		soma = soma + doces.docesapc[i]*doces.distrdoces[clareira][i]
	end
	doces.clareiracusto[clareira] = doces.clareiradif[clareira]/soma

end

function doces.custototal()
	custotot = 0
	for i,j in ipairs(doces.clareiracusto) do
		custotot = custotot+j
	end
	return custotot
end

function doces.combinardocesinicial() --acha uma distribuicao inicial
	local doce, clareira
	while doces.distrdoces[11][1]+doces.distrdoces[11][2]+doces.distrdoces[11][3]+doces.distrdoces[11][4]+doces.distrdoces[11][5] > 1 do
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
	end
end

--[[--

combinardocesinicial()

for i,j in pairs(distrdoces) do  --print da distribuicao inicial
	print("clareira",i)
	for k,l in ipairs(j) do
		print(k, l)
	end

end


custototal()
print(custotot)
]]

return doces
