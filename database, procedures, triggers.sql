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
go
create trigger t_requisicao on requisicao
after insert, update
as
begin
	if ((select segundos from inserted) > 60) begin
		raiserror('Timeout: Tempo da requisicao ultrapassou 60s.', 16, 1)
		rollback transaction
	end
	else if ((select codigo_http from inserted) < 100 or (select codigo_http from inserted) > 599) begin
		raiserror('Erro na Requisicao: Codigo HTTP Invalido', 16, 1)
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

go
create trigger t_sessao on sessao
after insert, update
as
begin
	declare @usuario_ip varchar(20),
			@i				int,
			@pontos			int,
			@octeto	varchar(5),
			@valido			bit
	set @usuario_ip = (select usuario_ip from inserted)
	set @valido = 1
	if (ISNUMERIC(SUBSTRING(@usuario_ip, 1, 1)) = 0 or (SUBSTRING(@usuario_ip, 1, 1) = '.')
	or (SUBSTRING(@usuario_ip, 1, 1) = '+') or (SUBSTRING(@usuario_ip, 1, 1) = '-')) begin
		set @valido = 0
	end
	else begin
		set @i = 2
		set @pontos = 0
		set @octeto = SUBSTRING(@usuario_ip, 1, 1)
		while ((select (SUBSTRING(@usuario_ip, @i, 1))) != '') begin
			if (SUBSTRING(@usuario_ip, @i, 1) = '.') begin
				if (@octeto = '') begin
					set @valido = 0
				end
				else begin
					if (cast(@octeto as int) > 255 or cast(@octeto as int) < 0) begin
						set @valido = 0
					end
					else begin
						set @pontos = @pontos + 1
						set @octeto = ''
					end
				end
			end
			else if (ISNUMERIC(SUBSTRING(@usuario_ip, @i, 1)) = 0 or (SUBSTRING(@usuario_ip, @i, 1)) = '+' or (SUBSTRING(@usuario_ip, @i, 1) = '-')) begin
				set @valido = 0
			end 
			else if (ISNUMERIC(SUBSTRING(@usuario_ip, @i, 1)) = 1) begin
				set @octeto = @octeto + (SUBSTRING(@usuario_ip, @i, 1))
			end
			set @i = @i + 1
		end
		if (cast(@octeto as int) > 255 or cast(@octeto as int) < 0) begin
			set @valido = 0
		end
		if (@pontos < 3) begin
			set @valido = 0
		end
		if (SUBSTRING(@usuario_ip, (@i - 1), 1) = '.' or SUBSTRING(@usuario_ip, (@i - 1), 1) = '+' or SUBSTRING(@usuario_ip, (@i - 1), 1) = '-') begin
			set @valido = 0
		end
	end
	if (@valido = 0) begin
		raiserror('Erro ao Inserir Sessao: IP invalido', 16, 1)
		rollback transaction
	end
end

go
create trigger t_link on link
after insert, update
as 
begin
	declare @link_target varchar(7)
	set @link_target = (select link_target from inserted)
	if (@link_target != '_self' and @link_target != '_parent' and @link_target != '_blank' and @link_target != '_top') begin
		raiserror('Erro ao Inserir Link: Target Invalido', 16, 1)
		rollback transaction
	end
end
