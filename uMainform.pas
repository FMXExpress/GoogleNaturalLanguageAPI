unit uMainform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.StdCtrls,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.ObjectScope, FMX.Memo.Types, FMX.Memo, FireDAC.Stan.StorageBin,
  FMX.WebBrowser, FMX.Edit, FMX.Layouts;

type
  TMainForm = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    StringGrid1: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Button1: TButton;
    RequestMemo: TMemo;
    MaterialOxfordBlueSB: TStyleBook;
    WebBrowser1: TWebBrowser;
    LinkPropertyToFieldURL: TLinkPropertyToField;
    Splitter1: TSplitter;
    Layout1: TLayout;
    Edit1: TEdit;
    LinkControlToField1: TLinkControlToField;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure SetPermissions;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.JSON, System.Win.Registry;

{$IFDEF MSWINDOWS}
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LinkPropertyToFieldURL.Active := False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  SetPermissions;
{$ENDIF}
end;

procedure TMainForm.SetPermissions;

const
  cHomePath = 'SOFTWARE';
  cFeatureBrowserEmulation =
    'Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\';
  cIE11 = 11001;

var
  Reg: TRegIniFile;
  sKey: string;
begin

  sKey := ExtractFileName(ParamStr(0));
  Reg := TRegIniFile.Create(cHomePath);
  try
    if Reg.OpenKey(cFeatureBrowserEmulation, True) and
      not(TRegistry(Reg).KeyExists(sKey) and (TRegistry(Reg).ReadInteger(sKey)
      = cIE11)) then
      TRegistry(Reg).WriteInteger(sKey, cIE11);
  finally
    Reg.Free;
  end;

end;
{$ENDIF}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  var JsonObject := TJSONObject.Create;
  try
    var document := TJSONObject.Create;
    document.AddPair(TJSONPair.Create('type', 'PLAIN_TEXT'));
    document.AddPair(TJSONPair.Create('content', RequestMemo.Lines.Text));
    JsonObject.AddPair(TJSONPair.Create('document', document));

    RESTRequest1.Params[0].Value := JsonObject.ToJSON;
    RESTRequest1.Execute;
  finally
    JsonObject.Free;
  end;
end;

end.
