unit MD.View.Client.Objects;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.TabControl, FMX.Edit,
  System.Generics.Collections, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.ObjectScope, FMX.Layouts,
  GBClient.Interfaces, System.JSON, REST.Json;

type
  TClient = class
  private
    Fname: string;
    FlastName: String;
    Fid: Integer;
    Fphone: String;
  public
    property id: Integer read Fid write Fid;
    property name: string read Fname write Fname;
    property lastName: String read FlastName write FlastName;
    property phone: String read Fphone write Fphone;
  end;

  TfrmMobileDayObject = class(TForm)
    Rectangle1: TRectangle;
    Label5: TLabel;
    tbcClient: TTabControl;
    tiList: TTabItem;
    tiCrud: TTabItem;
    tiSettings: TTabItem;
    lvClients: TListView;
    btnAdd: TCircle;
    Rectangle3: TRectangle;
    Label2: TLabel;
    edtName: TEdit;
    Label3: TLabel;
    edtLastName: TEdit;
    Label4: TLabel;
    edtPhone: TEdit;
    btnSave: TCircle;
    Path1: TPath;
    Path2: TPath;
    Path3: TPath;
    Rectangle2: TRectangle;
    Label1: TLabel;
    edtBaseUrl: TEdit;
    btnClear: TSpeedButton;
    adpClient: TDataGeneratorAdapter;
    absClients: TAdapterBindSource;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkListControlToField1: TLinkListControlToField;
    VertScrollBox1: TVertScrollBox;
    LinkControlToField3: TLinkControlToField;
    procedure FormCreate(Sender: TObject);
    procedure tbcClientChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lvClientsButtonClick(const Sender: TObject; const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure absClientsCreateAdapter(Sender: TObject; var ABindSourceAdapter: TBindSourceAdapter);
    procedure btnClearClick(Sender: TObject);
    procedure lvClientsItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure btnSaveClick(Sender: TObject);
  private
    FClients : TObjectList<TClient>;
    FRequest : IGBClientRequest;

    function PrepareRequest: IGBClientRequest;

    procedure refreshList;

    procedure listAll;
    procedure Insert(AClient: TClient);
    procedure Update(AClient: TClient);
    procedure Delete;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMobileDayObject: TfrmMobileDayObject;

implementation

{$R *.fmx}

procedure TfrmMobileDayObject.absClientsCreateAdapter(Sender: TObject; var ABindSourceAdapter: TBindSourceAdapter);
begin
  FClients := TObjectList<TClient>.create;

  ABindSourceAdapter := TListBindSourceAdapter<TClient>
                          .Create(Self, FClients);

  ABindSourceAdapter.AutoEdit := True;
  ABindSourceAdapter.Active := True;
end;

procedure TfrmMobileDayObject.btnAddClick(Sender: TObject);
begin
  tbcClient.ActiveTab := tiCrud;
  absClients.Insert;
end;

procedure TfrmMobileDayObject.btnClearClick(Sender: TObject);
var
  client : TClient;
begin
  client := FClients[lvClients.ItemIndex];
  if client.id = 0 then
    absClients.Delete
  else
    absClients.Cancel;

  tbcClient.ActiveTab := tiList;
end;

procedure TfrmMobileDayObject.btnSaveClick(Sender: TObject);
var
  client : TClient;
begin
  absClients.Post;
  client := FClients[lvClients.ItemIndex];

  if client.id <= 0 then
    Insert(client)
  else
    Update(client);

  tbcClient.ActiveTab := tiList;
end;

procedure TfrmMobileDayObject.Delete;
var
  client : TClient;
begin
  client := FClients[lvClients.ItemIndex];

  PrepareRequest
    .DELETE
    .Resource('client/{id}')
    .ParamPath
      .AddOrSet('id', client.id)
    .&End
    .Send;
end;

procedure TfrmMobileDayObject.FormCreate(Sender: TObject);
begin
  FRequest := NewClientRequest;

  tbcClient.ActiveTab   := tiList;
  tbcClient.TabPosition := TTabPosition.None;

  listAll;
end;

procedure TfrmMobileDayObject.Insert(AClient: TClient);
begin
  PrepareRequest
    .POST
    .Resource('client')
    .Body
      .AddOrSet(AClient)
    .&End
    .Send
    .GetObject(AClient);
end;

procedure TfrmMobileDayObject.listAll;
begin
  try
    FClients.Clear;
      PrepareRequest
        .GET
        .Resource('client')
        .Send
        .GetList(TList<TObject>(FClients), TClient);

    refreshList;
  except
    on E: Exception do
      ShowMessage(e.Message);
  end;
end;

procedure TfrmMobileDayObject.lvClientsButtonClick(const Sender: TObject; const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
  tbcClient.ActiveTab := tiList;
  Delete;
  absClients.Delete;
end;

procedure TfrmMobileDayObject.lvClientsItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  tbcClient.ActiveTab := tiCrud;
end;

function TfrmMobileDayObject.PrepareRequest: IGBClientRequest;
begin
  FRequest
    .BaseURL(edtBaseUrl.Text)
    .Authorization
      .Basic
        .Username('mobileDay')
        .Password('2020')
      .&End
    .&End;

  result := FRequest;
end;

procedure TfrmMobileDayObject.refreshList;
begin
  TListBindSourceAdapter<TClient>(absClients).Refresh;
end;

procedure TfrmMobileDayObject.tbcClientChange(Sender: TObject);
begin
  btnClear.Visible := tbcClient.ActiveTab = tiCrud;
end;

procedure TfrmMobileDayObject.Update(AClient: TClient);
begin
  PrepareRequest
    .PUT
    .Resource('client/' + AClient.id.ToString)
    .Body
      .AddOrSet(AClient)
    .&End
    .Send;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
