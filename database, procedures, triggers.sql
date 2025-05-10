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
	id	bigint	not null
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
	codigoHTML		varchar(max)	not null,
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
			/*antes, o IP a ser inserido precisa ser validado. nao sei o que eh um IP valido entao nao criarei a procedure de valicadao ainda*/
			insert into usuario values (@usuarioId, @usuarioIp, @usuarioNome)
			set @saida = 'Novo usuario '+@usuarioNome+' (ID: #'+cast(@usuarioId as varchar(10))+' IP: '+@usuarioIp+') criado com sucesso.'
		end
		else if (upper(@opc) = 'U')
		begin
			if ((select id from usuario where id = @usuarioId) is not null)
			begin
				update usuario
				set nome = @usuarioNome, usuarioIp = @usuarioIp where id = @usuarioId
				set @saida = 'Usuario '+@usuarioNome+' (ID: #'+cast(@usuarioId as varchar(10))+' IP: '+@usuarioIp+') atualizado com sucesso.'
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
create procedure sp_sessao (@opc char(1), @usuarioId bigint, @saida varchar(100) output)
as
begin
	
end