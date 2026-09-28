# vm-edata-converter

This is a set of code split out from an earlier project to convert information from the Norwegian gov pollution database [Vannmiljø](https://vannmiljo.miljodirektoratet.no/) to the [eData format](https://github.com/NIVANorge/eDataDRF).

# Some important details:

- Vannmijø is mostly defined here: https://vannmiljokoder.miljodirektoratet.no/location

- It has an [API](ttps://vannmiljoapi.miljodirektoratet.no/swagger/ui/index#/Public), but I don't believe it's been updated in some time

# Some thoughts:

The chief difficulties of converting Vannmiljø data are, broadly, as follows:

1. Converting between any two formats is always difficult

2. Vannmiljø by design doesn't capture a lot of information about a lot of things. Thus, when converting to a more detailed format, you either have to guess or omit.

3. Vannmiljø is a very big dataset representing an extraordinarily complex and heterogenous dataset, beyond its original scope (i.e. water pollution). It is difficult to understand.

4. Much important metadata for the interpretation of a given point is stored in reports. These can generally be found with help of Googling, but there's no automatic way to link this information to a report. 

5. Data are (mostly) in Norwegian.

6. Column names have been known to change.

7. Vannmiljø and its format are not formally versioned. The format is documented, but none of the documentation discusses versions or timestamps. 

8. Data are imported into Vannmiljø (as far as I understand) using Excel templates. 

9. I am not aware of what validation processes are carried out on data before entry to Vannmiljø. Data are extensively QC'd during the report-writing process, but it's not clear to me what automated/manual checks are performed on data in the database, and what processes there are for correction/reconciliation/etc. 

So:

## What this is (will be)

This is a set of scripts and functions designed to assist in the validation, intepretation and conversion of data from the database Vannmiljø and its formats to the eData format.

## What this isn't

- This is not a set of automated conversion scripts. We cannot and should not fully automate decision-making about conversion and interpretation.

- This does not remove the need to validate the data before and after conversion. We cannot automate this.

# To Do

1. Set up Quarto/pkgdown documentation

2. Inventory lookups, add pointblank validation

3. Inventory data-in, add pointblank validation

4. Document what we skip/ignore and why

# How to use these tools:

1. Download your data from Vannmiljø (sites, measurements).

2. Run validation on this data. Check that it is of the expected format. Inspect it manually in Excel

3. Use `pointblank::scan_data(data, sections = "OVMS")` to inspect the data.

# Getting Data from Vm

Even this stage isn't easy, because there's no way (that I can see) to, for example, just get the ecotox relevant data. If you want to select campaigns, you can only select one at a time. 

If we look, for example, at data for Oslo for 01/01/2020 to 31/01/2020. See `example_jan_oslo_vm_data.R`