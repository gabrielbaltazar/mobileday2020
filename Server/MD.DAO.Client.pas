unit MD.DAO.Client;

interface

uses
  MD.Model.Classes,
  System.Generics.Collections,
  System.SysUtils;

type TDAOClient = class

  private

    function CopyClient(AClient: TClient): TClient;
  public
    procedure insert(Client: TClient);
    procedure update(Client: TClient);
    procedure delete(Id: Integer);
    function listAll: TObjectList<TClient>;
    function find(Id: Integer): TClient;

    constructor create;
end;

var
  Clients: TObjectList<TClient>;

procedure initialDb;

implementation

procedure initialDb;
var
  i: Integer;
begin
  for i := 1 to 10 do
  begin
    Clients.Add(TClient.Create);
    Clients.Last.id := i;
    Clients.Last.name     := 'Client ' + i.ToString;
    Clients.Last.lastName := 'LastName ' + i.ToString;
    Clients.Last.phone  := Format('%6.9d',[i]);;
  end;
end;

{ TDAOClient }

function TDAOClient.CopyClient(AClient: TClient): TClient;
begin
  result := TClient.Create;
  try
    Result.id       := AClient.id;
    result.name     := AClient.name;
    result.lastName := AClient.lastName;
    result.phone    := AClient.phone;
  except
    Result.Free;
    raise;
  end;
end;

constructor TDAOClient.create;
begin
  
end;

procedure TDAOClient.delete(Id: Integer);
var
  auxClient: TClient;
begin
  auxClient := find(Id);
  if not Assigned(auxClient) then
    raise Exception.CreateFmt('Client %s not found.', [Id.ToString]);

  Clients.Remove(auxClient);
end;

function TDAOClient.find(Id: Integer): TClient;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to Pred(Clients.Count) do
  begin
    if Clients[i].id = id then
      Exit(Clients[i])
  end;
end;

procedure TDAOClient.insert(Client: TClient);
var
  auxClient: TClient;
begin
  auxClient := CopyClient(Client);
  try
    auxClient.id := Clients.Last.id + 1;
    Clients.Add(auxClient);
    Client.id := auxClient.id;
  except
    auxClient.Free;
  end;
end;

function TDAOClient.listAll: TObjectList<TClient>;
begin
  result := Clients;
end;

procedure TDAOClient.update(Client: TClient);
var
  auxClient: TClient;
begin
  auxClient := find(Client.id);
  if not Assigned(auxClient) then
    raise Exception.CreateFmt('Client %s not found.', [Client.id]);

  auxClient.name     := Client.name;
  auxClient.lastName := Client.lastName;
  auxClient.phone    := Client.phone;
end;

initialization
  Clients := TObjectList<TClient>.create;
  initialDb;

finalization
  Clients.Free;

end.
