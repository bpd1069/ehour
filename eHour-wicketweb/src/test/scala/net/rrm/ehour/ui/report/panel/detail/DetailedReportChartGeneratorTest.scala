package net.rrm.ehour.ui.report.panel.detail

import org.scalatest.matchers.ShouldMatchers
import org.scalatest.{BeforeAndAfter, FunSuite}
import net.rrm.ehour.config.EhourConfigStub
import net.rrm.ehour.ui.report.panel.DetailedReportDataObjectMother
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class DetailedReportChartGeneratorTest extends FunSuite with ShouldMatchers with BeforeAndAfter {
  var chart: String = _
  val reportData = DetailedReportDataObjectMother.getFlatReportData

  before {
    chart = DetailedReportChartGenerator.generateHourBasedDetailedChart("container", reportData, new EhourConfigStub())
  }

  test("should have series type of column with zoomtype") {
    chart should include("""chart:{"renderTo":"container","defaultSeriesType":"column","zoomType":"x"}""")
  }

  test("should have x axis set to datetime with zoom") {
    chart should include("""xAxis:[{"type":"datetime","maxZoom":3}]""")
  }

  test("should have y axis set to Hours") {
    chart should include("""yAxis:[{"title":{"text":"Hours"}}]""")
  }

  test("should have hourly based data set") {
    chart should include("""series:[{"name":"A Company","data":[0,8,7,6,5,0]}]""")
  }

  test("should have proper title set") {
    chart should include("""title:{"text":"Hours booked on customers per day"}""")
  }

  test("should have proper tooltip") {
    chart should include("""tooltip:{"formatter":function() { return new Date(this.x).toLocaleDateString() + '<br />' + this.series.name + ': ' + this.y.toLocaleString() + ' hours' } },""")
  }





}