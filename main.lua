--Funcao combinatoria dos doces por clareira
doces = require ("combinatoria")

--Mapa de caracteres lido do arquivo
local mapa = {}
local size = 41

--Posição da chapeuzinho e da casa da vovó
local chapeuzinhox, chapeuzinhoy, vovox, vovoy

--Tempo que se passou desde o último período de update
local tempo = 0

--Velocidade em passos por segundo
local velocidade = 100

--Imagens
local floresta, galhos, plano, cabana, inicio, clareira, chapuzinho, floresta_ponto, galhos_ponto, plano_ponto, clareira_ponto
local sprites_size = 17

--Tabelas para a busca A*,  com posição custo g e h, index do nó pai e um booleano que indica se o nó já foi visitado
--Um nó é representado por um index, que vale para todas as tabelas
local nos_x = {}
local nos_y = {}
local nos_g = {}
local nos_h = {}
local nos_pai = {}
local nos_visitado = {}
local corrente
local busca_concluida = false

local clareira_corrente = 0

--Função que retorna true caso a casajá exista nas tabelas e false caso contrário
function casa_nunca_vista (x, y)
	if x<1 or x>41 or y<1 or y>41 then
		return false
	end
    for index, value in ipairs (nos_x) do
        if value == x then
		if nos_y[index] == y then
			return false
		end
        end
    end
    return true
end

--Função que retorna o index do nó aberto de menor custo
function menor_custo()
	local index_minimo = 1
	local custo_minimo = 99999
	for  index, value in ipairs (nos_g) do
		if nos_visitado[index] == false then
			if (value + nos_h[index]) < custo_minimo then
				index_minimo = index
				custo_minimo = (value + nos_h[index])
			end
		end
	end
	return index_minimo
end

--Função que calcula o custo guloso g(x)
function g(x,y, pai)
	if mapa[x][y] == "D" then
		return (200 + nos_g[pai])
	elseif mapa[x][y] == "G" then
		return (5 + nos_g[pai])
	elseif mapa[x][y] == "C" then
		clareira_corrente = clareira_corrente + 1
		return (doces.clareiracusto[clareira_corrente] + nos_g[pai])
	else
		return (1 + nos_g[pai])
	end
end

--Função que calcula o custo heurístico h(x)
function h(x,y)
	return math.sqrt((y - vovoy)*(y - vovoy) + (x - vovox)*(x - vovox))
end

--Função de inicialização
function love.load()

	--Ajusta a tela
	love.window.setMode( sprites_size*size + 300, sprites_size*size)

	love.window.setTitle("Chapeuzinho Vermelho")

	doces.combinardocesinicial()


	--Passa o conteúdo do arquivo mapa para a tabela mapa
	file = love.filesystem.read("mapa.txt", 10000)
	index = 1
	for i = 1,size do
		mapa[i] = {}
		for j = 1,size do
			mapa[i][j] = file:sub(index,index)
			if mapa[i][j] == "I" then
				chapeuzinhox = i;
				chapeuzinhoy = j;
			end
			if mapa[i][j] == "F" then
				vovox = i;
				vovoy = j;
			end
			index = index+1
		end
		index = index+2
	end

	--Passa o conteúdo do arquivo velocidade
	file = love.filesystem.read("velocidade.txt", 100)
	velocidade = tonumber(file)


	--Importa as imagens
	floresta = love.graphics.newImage("resources/floresta.png")
	galhos = love.graphics.newImage("resources/galhos.png")
	plano = love.graphics.newImage("resources/plano.png")
	cabana = love.graphics.newImage("resources/cabana.png")
	clareira = love.graphics.newImage("resources/clareira.png")
	inicio = love.graphics.newImage("resources/inicio.png")
	chapeuzinho = love.graphics.newImage("resources/chapeuzinho.png")
	floresta_ponto = love.graphics.newImage("resources/floresta_ponto.png")
	galhos_ponto = love.graphics.newImage("resources/galhos_ponto.png")
	plano_ponto = love.graphics.newImage("resources/plano_ponto.png")
	clareira_ponto = love.graphics.newImage("resources/clareira_ponto.png")

	--Carrega a m�sica
	music = love.audio.newSource("resources/music.mp3")
	music:play()

	-- Inicializacao do A*

	corrente = 1
	nos_x[1] = chapeuzinhox
	nos_y[1] = chapeuzinhoy
	nos_g[1] = 0
	nos_h[1] = h(chapeuzinhox, chapeuzinhoy)
	nos_visitado[1] = true
	nos_pai[1] = 0

end

--Funcao chamada a cada período de tempo
function love.update(dt)
	tempo = tempo + dt
	if (tempo > 1/velocidade) and (busca_concluida~=true) then
		tempo = 0

		-- Busca A*

		--Testa se a busca chegou ao fim
		if nos_x[corrente] ~= vovox or nos_y[corrente] ~= vovoy then

			--Bota os nós vizinhos não visitados na lista de nós, calculando seus custos
			--Casa de cima
			if casa_nunca_vista ( nos_x[corrente],  nos_y[corrente]+1) then
				table.insert( nos_x, nos_x[corrente])
				table.insert( nos_y, nos_y[corrente]+1)
				table.insert( nos_pai, corrente)
				table.insert( nos_visitado, false)
				table.insert( nos_g, g(nos_x[corrente],  nos_y[corrente]+1, corrente))
				table.insert( nos_h, h(nos_x[corrente],  nos_y[corrente]+1))
			end
			--Casa de baixo
			if casa_nunca_vista ( nos_x[corrente],  nos_y[corrente]-1) then
				table.insert( nos_x, nos_x[corrente])
				table.insert( nos_y, nos_y[corrente]-1)
				table.insert( nos_pai, corrente)
				table.insert( nos_visitado, false)
				table.insert( nos_g, g(nos_x[corrente],  nos_y[corrente]-1, corrente))
				table.insert( nos_h, h(nos_x[corrente],  nos_y[corrente]-1))
			end
			--Casa da direita
			if casa_nunca_vista ( nos_x[corrente]+1,  nos_y[corrente]) then
				table.insert( nos_x, nos_x[corrente]+1)
				table.insert( nos_y, nos_y[corrente])
				table.insert( nos_pai, corrente)
				table.insert( nos_visitado, false)
				table.insert( nos_g, g(nos_x[corrente]+1,  nos_y[corrente], corrente))
				table.insert( nos_h, h(nos_x[corrente]+1,  nos_y[corrente]))
			end
			--Casa da esquerda
			if casa_nunca_vista ( nos_x[corrente]-1,  nos_y[corrente]) then
				table.insert( nos_x, nos_x[corrente]-1)
				table.insert( nos_y, nos_y[corrente])
				table.insert( nos_pai, corrente)
				table.insert( nos_visitado, false)
				table.insert( nos_g, g(nos_x[corrente]-1,  nos_y[corrente], corrente))
				table.insert( nos_h, h(nos_x[corrente]-1,  nos_y[corrente]))
			end

			--Procura o nó aberto com menor custo e altera o corrente
			nos_visitado[corrente] = true
			corrente = menor_custo()

			chapeuzinhox = nos_x[corrente]
			chapeuzinhoy = nos_y[corrente]

		else

			--Faz o "desenho" do caminho encontrado na busca, começando do final e indo de pai em pai
			i = corrente
			while i ~= 1 do
				if mapa[nos_x[i]][nos_y[i]] == "D" then
					mapa[nos_x[i]][nos_y[i]] = "d"
				elseif mapa[nos_x[i]][nos_y[i]] == "G" then
					mapa[nos_x[i]][nos_y[i]] = "g"
				elseif mapa[nos_x[i]][nos_y[i]] == "C" then
					mapa[nos_x[i]][nos_y[i]] = "c"
				elseif mapa[nos_x[i]][nos_y[i]] == "." then
					mapa[nos_x[i]][nos_y[i]] = ":"
				end
				i = nos_pai[i]
			end
			busca_concluida = true
		end
	end
end

--Função de desenha do LOVE
function love.draw()

	--Escreve o custo da casa
	love.graphics.print("Custo:", sprites_size*size + 10, 10)
	love.graphics.print("g(x) = " .. nos_g[corrente], sprites_size*size + 10, 25)
	love.graphics.print("h(x) = " .. nos_h[corrente], sprites_size*size + 10, 40)
	love.graphics.print("g(x) + h(x) = " .. nos_g[corrente]+nos_h[corrente], sprites_size*size + 10, 55)


	if busca_concluida then

		love.graphics.print("Custo nas clareiras = " .. doces.custototal(), sprites_size*size + 10, 70)

		--Escreve a distribuicao de doces
		love.graphics.print("Distribuicao dos doces:", sprites_size*size + 10, 100)
		for i,j in pairs(doces.distrdoces) do
			if i == 11 then
				love.graphics.print("Cesta ", sprites_size*size + 10, 115 + 30*(i-1))
			else
				love.graphics.print("Clareira " .. i, sprites_size*size + 10, 115 + 30*(i-1))
			end
			for k,l in ipairs(j) do
				love.graphics.print(l, sprites_size*size + 10*k, 130 + 30*(i-1))
			end

		end

	end

	--Desenha o mapa
	for i = 1,size do
		for j = 1,size do
			if i == chapeuzinhox and j == chapeuzinhoy and busca_concluida == false then
				love.graphics.draw(chapeuzinho, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "D" then
				love.graphics.draw(floresta, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "G" then
				love.graphics.draw(galhos, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "." then
				love.graphics.draw(plano, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "F" then
				love.graphics.draw(cabana, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "C" then
				love.graphics.draw(clareira, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "I" then
				love.graphics.draw(inicio, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "d" then
				love.graphics.draw(floresta_ponto, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "g" then
				love.graphics.draw(galhos_ponto, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == "c" then
				love.graphics.draw(clareira_ponto, sprites_size*(j-1), sprites_size*(i-1))
			elseif mapa[i][j] == ":" then
				love.graphics.draw(plano_ponto, sprites_size*(j-1), sprites_size*(i-1))
			end
		end
	end
end

--Funcao de leitura de teclas pressionadas
function love.keypressed(key)
	 if key == "escape" then
		local pressedbutton = love.window.showMessageBox("Sair", "Deseja fechar?", {"Sim", "Nao", escapebutton = 2})
		if pressedbutton == 1 then
			love.event.push('quit')
		elseif pressedbutton == 2 then
		      -- Nao apertado,fazer nada
		end
	end
end

