--CRIACAO
create database TrabalhoLabBd2
go
use TrabalhoLabBd2
go
--EXCLUSAO E RECRIACAO
use master
go
drop database TrabalhoLabBd2
go
create database TrabalhoLabBd2
go
use TrabalhoLabBd2
go
------------------------------
create table sessao (
	id			bigint	not null,
	usuario_id	bigint	not null
	primary key(id)
)
go
create table usuario (
	id			bigint		not null,
	usuario_ip	varchar(20)	not null,
	nome		varchar(30)	not null,
	primary key(id)
)
go
create table logs (
	id			bigint			not null,
	mensagem	varchar(200)	not null,
	sessao_id	bigint			not null
	primary key(id)
	foreign key(sessao_id) references sessao(id)
)
go
create table pagina (
	id						bigint			not null,
	codigo_html				nvarchar(max)	not null,
	tipo_conteudo			varchar(30)		not null,
	pagina_url				varchar(500)	not null,
	tamanho_arquivo_bytes	int				not null
	primary key(id)
)
go
create table requisicao (
	id			bigint			not null,
	codigo_http	varchar(200)	not null,
	segundos	int				not null,
	sessao_id	bigint			not null,
	pagina_id	bigint			not null
	primary key(id)
	foreign key(sessao_id) references sessao(id),
	foreign key(pagina_id) references pagina(id)
)
go
create table link (
	id			bigint			not null,
	url_destino	varchar(500)	not null,
	titulo		varchar(100)	null,
	link_target		varchar(7)	not null
	primary key(id)
)
go
create table pagina_link (
	pagina_id	bigint	not null,
	link_id		bigint	not null
	primary key(pagina_id, link_id)
	foreign key(pagina_id) references pagina(id),
	foreign key(link_id) references link(id)
)
------------------------------------------------------------------
go
create procedure sp_usuario (@opc char(1), @usuarioId bigint, @usuarioIp varchar(20), @usuarioNome varchar(30), @saida varchar(100) output)
as
begin
	if (@usuarioId is not null)
	begin
		if (upper(@opc) = 'I')
		begin
			if (@usuarioIp is not null and @usuarioNome is not null)
			begin
				if ((select id from usuario where id = @usuarioId) is null)
				begin
					/*antes, o IP a ser inserido precisa ser validado. nao sei o que eh um IP valido entao nao criarei a procedure de valicadao ainda*/
					insert into usuario values (@usuarioId, @usuarioIp, @usuarioNome)
					set @saida = 'Novo usuario '+@usuarioNome+' (ID: #'+cast(@usuarioId as varchar(10))+' IP: '+@usuarioIp+') criado com sucesso.'
				end
				else
				begin
					raiserror('Erro ao adicionar usuario: este ID ja existe.', 16, 1)
				end
			end
			else
			begin
				raiserror('Erro ao adicionar usuario: um ou mais campos estao em branco.', 16, 1)
			end			
		end
		else if (upper(@opc) = 'U')
		begin
			if ((select id from usuario where id = @usuarioId) is not null)
			begin
				if (@usuarioIp is not null and @usuarioNome is not null)
				begin
					update usuario
					set nome = @usuarioNome, usuario_ip = @usuarioIp where id = @usuarioId
					set @saida = 'Usuario '+@usuarioNome+' (ID: #'+cast(@usuarioId as varchar(10))+' IP: '+@usuarioIp+') atualizado com sucesso.'
				end
				else
				begin
					raiserror('Erro ao atualizar usuario: um ou mais campos estao em branco.', 16, 1)
				end
			end
			else
			begin
				raiserror('Erro ao atualizar usuario: ID nao existe', 16, 1)
			end			
		end
		else if (upper(@opc) = 'D')
		begin
			if ((select id from usuario where id = @usuarioId) is not null)
			begin
				set @usuarioNome = (select nome from usuario where id = @usuarioId)
				delete from usuario where id = @usuarioId
				set @saida = 'Usuario #' + cast(@usuarioId as varchar(10))+' '+@usuarioNome+' excluido com sucesso.'
			end
			else
			begin
				raiserror('Erro ao excluir usuario: ID nao existe', 16, 1)
			end
		end
	end
	else
	begin
		raiserror('Erro em Usuario: ID nulo', 16, 1)
	end	
end
go

create procedure sp_sessao (@opc char(1), @sessaoId bigint, @usuarioId bigint, @saida varchar(100) output)
as
begin
	if (@sessaoId is not null)
	begin
		declare @usuarioNome varchar(30)
		if (upper(@opc) = 'I')
		begin
			if ((select id from usuario where id = @usuarioId) is not null)
			begin
				if ((select id from sessao where id = @sessaoId) is null)
				begin
					insert into sessao values (@sessaoId, @usuarioId)
					set @usuarioNome = (select nome from usuario where id = @usuarioId)
					set @saida = 'Sessao #'+cast(@sessaoId as varchar(10))+' de Usuario '+@usuarioNome+' iniciada com sucesso.'
				end
				else
				begin
					raiserror('Erro ao iniciar Sessao: ID ja existe', 16, 1)
				end
				
			end
			else
			begin
				raiserror('Erro ao iniciar sessao: ID de usuario nao existe', 16, 1)
			end
		end
		else if (upper(@opc) = 'U')
		begin
			if ((select id from usuario where id = @usuarioId) is not null and (select id from sessao where id = @sessaoId) is not null)
			begin
				update sessao
				set usuario_id = @usuarioId where id = @sessaoId
				set @usuarioNome = (select nome from usuario where id = @usuarioId)
				set @saida = 'Sessao #'+cast(@sessaoId as varchar(10))+' atualizada para Usuario '+@usuarioNome+' com sucesso.'
			end
			else
			begin
				raiserror('Erro ao atualizar Sessao: Sessao ou Usuario inexistentes', 16, 1)
			end
		end
		else if (upper(@opc) = 'D')
		begin
			if ((select id from sessao where id = @sessaoId) is not null)
			begin
				delete from sessao where id = @sessaoId
			end
			else
			begin
				raiserror('Erro ao excluir sessao: ID inexistente', 16, 1)
			end
		end
	end
	else
	begin
		raiserror('Erro em Sessao: ID nulo', 16, 1)
	end
end

go
create procedure sp_log (@opc char(1), @logId bigint, @mensagem varchar(200), @sessaoId bigint, @saida varchar(100) output)
as
begin
	if (@logId is not null) begin
			if (upper(@opc) = 'I') begin
				if ((select id from logs where id = @logId) is null) begin
					if (@mensagem is not null and @sessaoId is not null) begin
						if ((select id from sessao where id = @sessaoId) is not null) begin
							insert into logs values (@logId, @mensagem, @sessaoId)
							set @saida = 'Log da Sessao #'+cast(@sessaoId as varchar(10))+' inserido com sucesso.'
						end
						else begin
							raiserror('Erro ao inserir Log: Sessao inexistente', 16, 1)
						end
					end
					else begin
						raiserror('Erro ao inserir Log: Mensagem ou Sessao nulos', 16, 1)
					end
				end
				else begin
					raiserror('Erro ao Inserir Log: ID ja existe', 16, 1)
				end
			end
			else begin 
				if ((select id from logs where id = @logId) is not null) begin
					if (upper(@opc) = 'U') begin
						if (@mensagem is not null and @sessaoId is not null) begin
							if ((select id from sessao where id = @sessaoId) is not null) begin
								update logs
								set mensagem = @mensagem, sessao_id = @sessaoId where id = @logId
								set @saida = 'Log #'+cast(@logId as varchar(10))+' - Sessao #'+cast(@sessaoId as varchar(10))+' atualizado com sucesso.'
							end
							else begin
								raiserror('Erro ao atualizar Log: Sessao inexistente', 16, 1)
							end
						end 
						else begin
							raiserror('Erro ao atualizar Log: Mensagem ou Sessao nulos', 16, 1)
						end
					end 
					else if (upper(@opc) = 'D') begin
						delete from logs where id = @logId
						set @saida = 'Log #'+cast(@logId as varchar(10))+' excluido com sucesso.'
					end
				end
				else begin
					raiserror('Erro ao atualizar Log: ID inexistente', 16, 1)
				end
			end
	end
	else begin
		raiserror('Erro em Log: ID nulo', 16, 1)
	end
end

go
create procedure sp_pagina	(@opc char(1), @paginaId bigint, @codigoHTML nvarchar(max), @tipoConteudo varchar(30),
							@paginaUrl varchar(500), @tamanhoArquivo varbinary(max), @saida varchar(100) output)
as
begin
	if (@paginaId is not null) begin
		if (upper(@opc) = 'I' or upper(@opc) = 'U') begin
			if (@codigoHTML is null or @tipoConteudo is null or @paginaUrl is null or @tamanhoArquivo is null) begin
				raiserror('Erro ao Inserir/Atualizar Pagina: uma ou mais informacoes em branco', 16, 1)
			end
			else begin
				if (upper(@opc) = 'I') begin
					if ((select id from pagina where id = @paginaId) is null) begin
						insert into pagina values (@paginaId, @codigoHTML, @tipoConteudo, @paginaUrl, @tamanhoArquivo)
						set @saida = 'Pagina #'+cast(@paginaId as varchar(10))+' inserida com sucesso.'
					end
					else begin
						raiserror('Erro ao Inserir Pagina: ID ja existe', 16, 1)
					end					
				end
				else if (upper(@opc) = 'U') begin
					if ((select id from pagina where id = @paginaId) is not null) begin
						update pagina
						set codigo_html = @codigoHTML, tipo_conteudo = @tipoConteudo, pagina_url = @paginaUrl, tamanho_arquivo_bytes = @tamanhoArquivo where id = @paginaId
						set @saida = 'Pagina #'+cast(@paginaId as varchar(10))+' atualizada com sucesso.'
					end
					else begin
						raiserror('Erro ao Atualizar Pagina: ID inexistente', 16, 1)
					end
				end
			end	
		end
		else if (upper(@opc) = 'D') begin
			delete from pagina where id = @paginaId
			set @saida = 'Pagina #'+cast(@paginaId as varchar(10))+' excluida com sucesso.'
		end
	end
	else begin
		raiserror('Erro em Pagina: ID nulo', 16, 1)
	end
end

go
create procedure sp_requisicao (@opc char(1), @id bigint, @coditoHTTP varchar(200), @segundos int, @sessaoId bigint, @paginaId bigint, @saida varchar(100) output)
as
begin
	if (@id is not null) begin
		if (upper(@opc) = 'I' or upper(@opc) = 'U') begin
			if (@coditoHTTP is null or @segundos is null or @sessaoId is null or @paginaId is null) begin
				raiserror('Erro ao Inserir/Atualizar Requisicao: uma ou mais informacoes estao em branco', 16, 1)
			end
			else begin
				if (upper(@opc) = 'I') begin
					if ((select id from requisicao where id = @id) is null) begin
						insert into requisicao values (@id, @coditoHTTP, @segundos, @sessaoId, @paginaId)
						set @saida = 'Requisicao #'+cast(@id as varchar(10))+' inserida com sucesso.'
					end
					else begin
						raiserror('Erro ao Inserir Requisicao: ID ja existe', 16, 1)
					end
				end
				else if (upper(@opc) = 'U') begin
					if ((select id from requisicao where id = @id) is null) begin
						raiserror('Erro ao Atualizar Requisicao: ID nao existe', 16, 1)
					end
					else begin
						update requisicao
						set codigo_http = @coditoHTTP, segundos = @segundos, sessao_id = @sessaoId, pagina_id = @paginaId where id = @id
						set @saida = 'Requisicao #'+cast(@id as varchar(10))+' atualizada com sucesso.'
					end
				end
			end
		end
		else if (upper(@opc) = 'D') begin
			if ((select id from requisicao where id = @id) is null) begin
				raiserror('Erro ao Excluir Requisicao: ID nao existe.', 16, 1)
			end
			else begin
				delete from requisicao where id = @id
				set @saida = 'Requisicao #'+cast(@id as varchar(10))+' excluida com sucesso.'
			end
		end
	end
	else begin
		raiserror('Erro em Requisicao: ID nulo', 16, 1)
	end
end

go
create procedure sp_link (@opc char(1), @linkId bigint, @urlDestino varchar(500), @titulo varchar(100), @target varchar(7), @saida varchar(100) output)
as
begin
	if (@linkId is null) begin
		raiserror('Erro em Link: ID nulo', 16, 1)
	end
	else begin
		if (upper(@opc) = 'I' or upper(@opc) = 'U') begin
			if (@urlDestino is null or @titulo is null or @target is null) begin
				raiserror('Erro ao Inserir/Atualizar Link: uma ou mais informacoes estao em branco.', 16, 1)
			end
			else begin
				if (upper(@opc) = 'I') begin
					if ((select id from link where id = @linkId) is not null) begin
						raiserror('Erro ao Inserir Link: ID ja existe.', 16, 1)
					end
					else begin
						insert into link values (@linkId, @urlDestino, @titulo, @target)
						set @saida = 'Link '+cast(@linkId as varchar(10))+' - '+@titulo+' inserido com sucesso.'
					end
				end
				else if (upper(@opc) = 'U') begin
					if ((select id from link where id = @linkId) is null) begin
						raiserror('Erro ao Atualizar Link: ID inexistente.', 16, 1)
					end
					else begin
						update link
						set url_destino = @urlDestino, titulo = @titulo, link_target = @target
						set @saida = 'Link '+cast(@linkId as varchar(10))+' - '+@titulo+' atualizado com sucesso.'
					end
				end
			end
		end
		else if (upper(@opc) = 'D')  begin
			if ((select id from link where id = @linkId) is null) begin
				raiserror('Erro ao Excluir Link: ID inexistente.', 16, 1)
			end
			else begin
				delete from link where id = @linkId
				set @saida = 'Link '+cast(@linkId as varchar(10))+' - '+@titulo+' excluido com sucesso.'
			end
		end
	end
end

go
create procedure sp_pagina_link (@opc char(1), @paginaId bigint, @linkId bigint, @saida varchar(100) output)
as
begin
	if (@paginaId is null or @linkId is null) begin
		raiserror('Erro em Pagina_Linl: um ou mais IDs nulos.', 16, 1)
	end
	else begin
		if (upper(@opc) = 'I') begin
			if ((select pagina_id from pagina_link where pagina_id = @paginaId and link_id = @linkId) is not null) begin
				raiserror('Erro ao Inserir Pagina_Link: IDs ja existentes.', 16, 1)
			end
			else begin
				insert into pagina_link values (@paginaId, @linkId)
				set @saida = 'Relacao de Pagina #'+cast(@paginaId as varchar(10))+' e Link #'+cast(@linkId as varchar(10))+' feita com sucesso.'
			end
		end
		else if (upper(@opc) = 'D') begin
			if ((select pagina_id from pagina_link where pagina_id = @paginaId and link_id = @linkId) is null) begin
				raiserror('Erro ao Excluir Pagina_Link: IDs nao existentes.', 16, 1)
			end
			else begin
				delete from pagina_link where pagina_id = @paginaId and link_id = @linkId
				set @saida = 'Relacao de Pagina #'+cast(@paginaId as varchar(10))+' e Link #'+cast(@linkId as varchar(10))+' excluida com sucesso.'
			end
		end
	end
end

go
create trigger t_requisicao on requisicao
after insert, update
as
begin

	if ((select segundos from inserted) > 60) begin
		raiserror('Timeout: Tempo da requisicao ultrapassou 60s.', 16, 1)
		rollback transaction
	end
end

go
create trigger t_pagina on pagina
after insert, update
as 
begin
	if ((select tamanho_arquivo_bytes from inserted) > 1000000) begin
		raiserror('Erro ao Inserir/Atualizar Pagina: arquivo > 1MB.', 16, 1)
		rollback transaction
	end
end

go
create function fn_qtd_referencias_link(@linkId bigint)
returns int
as
begin
	declare @qtdPaginas int
	set @qtdPaginas = (select count(link_id) from pagina_link where link_id = @linkId)
	return @qtdPaginas
end