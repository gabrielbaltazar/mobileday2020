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
  System.JSON, REST.Json;

type
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
    VertScrollBox1: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure tbcClientChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lvClientsButtonClick(const Sender: TObject; const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure btnClearClick(Sender: TObject);
    procedure lvClientsItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMobileDayObject: TfrmMobileDayObject;

implementation

{$R *.fmx}

procedure TfrmMobileDayObject.btnAddClick(Sender: TObject);
begin
  tbcClient.ActiveTab := tiCrud;
end;

procedure TfrmMobileDayObject.btnClearClick(Sender: TObject);
begin
  tbcClient.ActiveTab := tiList;
end;

procedure TfrmMobileDayObject.btnSaveClick(Sender: TObject);
begin
  tbcClient.ActiveTab := tiList;
end;

procedure TfrmMobileDayObject.FormCreate(Sender: TObject);
begin
  tbcClient.ActiveTab   := tiList;
  tbcClient.TabPosition := TTabPosition.None;
end;

procedure TfrmMobileDayObject.lvClientsButtonClick(const Sender: TObject; const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
  tbcClient.ActiveTab := tiList;
end;

procedure TfrmMobileDayObject.lvClientsItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  tbcClient.ActiveTab := tiCrud;
end;

procedure TfrmMobileDayObject.tbcClientChange(Sender: TObject);
begin
  btnClear.Visible := tbcClient.ActiveTab = tiCrud;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
