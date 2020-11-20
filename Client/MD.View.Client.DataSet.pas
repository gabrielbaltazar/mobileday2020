unit MD.View.Client.DataSet;

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
  GBClient.Interfaces, System.JSON, REST.Json, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.DBScope;

type
  TfrmMobileDayDataSet = class(TForm)
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
    VertScrollBox1: TVertScrollBox;
    dsClient: TFDMemTable;
    dsClientid: TIntegerField;
    dsClientname: TStringField;
    dsClientlastName: TStringField;
    dsClientphone: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    procedure FormCreate(Sender: TObject);
    procedure tbcClientChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lvClientsButtonClick(const Sender: TObject; const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure btnClearClick(Sender: TObject);
    procedure lvClientsItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure btnSaveClick(Sender: TObject);
  private
    FRequest : IGBClientRequest;

    function PrepareRequest: IGBClientRequest;

    procedure listAll;
    procedure Insert;
    procedure Update;
    procedure Delete;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMobileDayDataSet: TfrmMobileDayDataSet;

implementation

{$R *.fmx}

procedure TfrmMobileDayDataSet.btnAddClick(Sender: TObject);
begin
  tbcClient.ActiveTab := tiCrud;
  dsClient.Insert;
end;

procedure TfrmMobileDayDataSet.btnClearClick(Sender: TObject);
begin
  dsClient.Cancel;
  tbcClient.ActiveTab := tiList;
end;

procedure TfrmMobileDayDataSet.btnSaveClick(Sender: TObject);
begin
  if dsClient.State = dsInsert then
    Insert
  else
    Update;

  tbcClient.ActiveTab := tiList;
end;

procedure TfrmMobileDayDataSet.Delete;
begin
  PrepareRequest
    .DELETE
    .Resource('client/{id}')
    .ParamPath
      .AddOrSet('id', dsClient.FieldByName('id').AsInteger)
    .&End
    .Send;
end;

procedure TfrmMobileDayDataSet.FormCreate(Sender: TObject);
begin
  FRequest := NewClientRequest;

  tbcClient.ActiveTab   := tiList;
  tbcClient.TabPosition := TTabPosition.None;

  listAll;
end;

procedure TfrmMobileDayDataSet.Insert;
begin
  dsClient.Post;

  PrepareRequest
    .POST
    .Resource('client')
    .Body
      .AddOrSet(dsClient)
    .&End
    .Send;

  dsClient.Edit;
  dsClient.FieldByName('id').AsString := FRequest.Response.HeaderAsString('location');
  dsClient.Post;
end;

procedure TfrmMobileDayDataSet.listAll;
begin
  try
    PrepareRequest
      .GET
      .Resource('client')
      .Send
      .DataSet(dsClient)
  except
    on E: Exception do
      ShowMessage(e.Message);
  end;
end;

procedure TfrmMobileDayDataSet.lvClientsButtonClick(const Sender: TObject; const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
  tbcClient.ActiveTab := tiList;
  Delete;
  dsClient.Delete;
end;

procedure TfrmMobileDayDataSet.lvClientsItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  tbcClient.ActiveTab := tiCrud;
end;

function TfrmMobileDayDataSet.PrepareRequest: IGBClientRequest;
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

procedure TfrmMobileDayDataSet.tbcClientChange(Sender: TObject);
begin
  btnClear.Visible := tbcClient.ActiveTab = tiCrud;
end;

procedure TfrmMobileDayDataSet.Update;
begin
  dsClient.Post;

  PrepareRequest
    .PUT
    .Resource('client/' + dsClient.FieldByName('id').AsString)
    .Body
      .AddOrSet(dsClient)
    .&End
    .Send;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
