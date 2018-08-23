class DailyReportsController < ApplicationController
  before_action :set_daily_report, only: [:show, :confirm, :destroy]

  def show; end

  def coffee
    @daily_report = DailyReport.new(business: 'coffee')
    render :new
  end

  def restaurant
    @daily_report = DailyReport.new(business: 'restaurant')
    render :new
  end

  def create
    @daily_report = DailyReport.new(daily_report_params)
    @daily_report.user = current_user
    @daily_report.status = false
    if @daily_report.save
      redirect_to @daily_report, notice: 'Daily report was successfully created.'
    else
      render :new
    end
  end

  def confirm
    @daily_report.status = true
    if @daily_report.save
      GoogleSheetsWriter.new.write(@daily_report)
      redirect_to root_path, notice: 'Report confirmed!'
    else
      render :show, alert: 'could not confirm your report'
    end
  end

  def destroy
    @daily_report.destroy
    redirect_to new_daily_report_path, notice: "Report deleted! Please Redo the #{@meal} report"
  end

  private
    def set_daily_report
      @daily_report = DailyReport.find(params[:id])
    end

    def daily_report_params
      params.require(:daily_report).permit(:name_und_vorname, :date, :dinner_umsatz, :dinner_anzahl_personen, :lunch_umsatz, :lunch_anzahl_personen, :summe_lunchchecks, :mastercard, :visa, :maestro, :andere, :summe_treuekarte, :summe_rabatte, :summe_rechnung, :summe_gutschein, :gutschein_nummer, :summe_einkauf, :business)
    end
end
