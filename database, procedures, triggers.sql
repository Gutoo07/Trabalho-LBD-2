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
	usuarioId	bigint	not null
	primary key(id)
)
go
create table usuario (
	id			bigint		not null,
	usuarioIp	varchar(20)	not null,
	nome		varchar(30)	not null,
	primary key(id)
)
go
create table logs (
	id			bigint			not null,
	mensagem	varchar(200)	not null,
	sessaoId	bigint			not null
	primary key(id)
	foreign key(sessaoId) references sessao(id)
)
go
create table pagina (
	id				bigint			not null,
	codigoHTML		nvarchar(max)	not null,
	tipoConteudo	varchar(30)		not null,
	paginaUrl		varchar(500)	not null,
	tamanhoArquivo	varbinary(max)	not null
	primary key(id)
)
go
create table requisicao (
	id			bigint			not null,
	codigoHTTP	varchar(200)	not null,
	segundos	int				not null,
	sessaoId	bigint			not null,
	paginaId	bigint			not null
	primary key(id)
	foreign key(sessaoId) references sessao(id),
	foreign key(paginaId) references pagina(id)
)
go
create table link (
	id			bigint			not null,
	urlDestino	varchar(500)	not null,
	titulo		varchar(100)	null,
	linkTarget		varchar(7)	not null
	primary key(id)
)
go
create table pagina_link (
	paginaId	bigint	not null,
	linkId		bigint	not null
	primary key(paginaId, linkId)
	foreign key(paginaId) references pagina(id),
	foreign key(linkId) references link(id)
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
					set nome = @usuarioNome, usuarioIp = @usuarioIp where id = @usuarioId
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
				set usuarioId = @usuarioId where id = @sessaoId
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
								set mensagem = @mensagem, sessaoId = @sessaoId where id = @logId
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
						set codigoHTML = @codigoHTML, tipoConteudo = @tipoConteudo, paginaUrl = @paginaUrl, tamanhoArquivo = @tamanhoArquivo where id = @paginaId
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
 