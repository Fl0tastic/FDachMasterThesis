# -*- coding: utf-8 -*-
# %% File reading
"""
Created on Wed Dec  1 15:15:30 2021

@author: Florian Dach, Hugo Boer
"""
import pandas as pd  
import math

loc = "Vessel Data Talbot.xls"
#loc = "Vessel Data Talbot Low.xls"
#loc = "Vessel Data Talbot High.xls"
loc2 = "Farm Data Talbot.xls"


Data_Vessel = pd.read_excel(loc, sheet_name='Vessel')	      # Vessel data sheet
Data_Operation = pd.read_excel(loc, sheet_name='Operation')   # Operation data sheet
Data_Farm = pd.read_excel(loc2) 		                      # Farm data sheet
Data_Scenario = pd.read_excel(loc, sheet_name='Scenarios')
Data_Limits = pd.read_excel(loc, sheet_name='Limits')

# creating dataframes for results

T_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                     index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
COST_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                        index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
WAIT_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                        index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])

Waiting_position = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                                index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_transfer = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                                index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_connect = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                               index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_tower = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                             index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_nacelle = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                               index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_blade = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                             index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_commission = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                                  index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_transit = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                               index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_wave = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                          index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_wind = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                            index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_WindWave = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                            index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])
Waiting_tide = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'],
                            index=["2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "Average (h)", "Average (days)"])

years = [2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020]

# %% Data input

# ------------Farm Characteristics------


N_TOW = Data_Farm.iloc[2, 2]								# Number of tower pieces per turbine
N_BLADE = Data_Farm.iloc[3, 2]							    # Number of blades per turbine
WD = Data_Farm.iloc[4, 2]                                   # Water depth
N_NAC = Data_Farm.iloc[5, 2]                                # Number of nacelle components per turbine (hub already mounted)
N_MOOR = Data_Farm.iloc[6, 2]                               # Number of moorings to be connected
PORT_DIS = Data_Farm.iloc[7, 2]                             # Distance between ports
# --------------Vessel Characteristics-----

# Installation vessel

TRANS_VEL = Data_Vessel.iloc[2, 2]                      # Transition Velocity of selected Foundation installation Vessel
CAP_WTB = Data_Vessel.iloc[3, 2]						# Loading capacity Foundation of selected Foundation installation Vessel
AIR = Data_Vessel.iloc[4, 2]					        # Air gap between vessel and sea level, only for jack-up Vessels
PEN_LEG = Data_Vessel.iloc[5, 2]				        # Penetration depth of the legs of jack-up vessel
JACK_SP = Data_Vessel.iloc[6, 2]				        # Jack-up-speed, only for jack-up vessels
LOWER_SP = Data_Vessel.iloc[7, 2]                       # Leg lowering speed
CHT_J = Data_Vessel.iloc[8, 2]				            # Day-rate charter cost jack-up vessel
CHT_B = Data_Vessel.iloc[9, 2]				            # Day-rate charter cost simple steel barge
CHT_T = Data_Vessel.iloc[10, 2]				            # Day-rate charter cost tug boat
CHT_CTV = Data_Vessel.iloc[11, 2]				        # Day-rate charter CTV
CHT_CR = Data_Vessel.iloc[12, 2]				        # Day-rate charter crew on boat
# ---------Operational limits ---------

HS_TRANS = Data_Limits.iloc[2, 1]                       # Significant wave height limit transportation
HS_POS = Data_Limits.iloc[2, 2]                         # Significant wave height limit positioning
TP_POS = Data_Limits.iloc[2, 3]                         # Wave period limit positioning
HS_LOAD = Data_Limits.iloc[2, 4]                        # Significant wave height limit component transfer
HS_CON = Data_Limits.iloc[2, 5]                         # Significant wave height limit floater connection
HS_TOW = Data_Limits.iloc[2, 6]                         # Significant wave height limit tower installation
TP_TOW = Data_Limits.iloc[2, 7]                         # Mean period limit tower installation
WS_TOW = Data_Limits.iloc[2, 8]                         # Wind speed limit tower
HS_NAC = Data_Limits.iloc[2, 9]                         # Significant wave height limit nacelle installation
TP_NAC = Data_Limits.iloc[2, 10]                        # Mean period limit nacelle installation
WS_NAC = Data_Limits.iloc[2, 11]                        # Wind speed limit nacelle installation
HS_BLADE = Data_Limits.iloc[2, 12]                      # Significant wave height limit blade installation
TP_BLADE = Data_Limits.iloc[2, 13]                      # Mean period limit blade installation
WS_BLADE = Data_Limits.iloc[2, 14]                      # Wind speed limit blade installation
HS_COMM = Data_Limits.iloc[2, 15]                       # Significant wave height limit commissioning
TI_POS = Data_Limits.iloc[2, 16]                        # Tide limit positioning
TI_LOAD = Data_Limits.iloc[2, 17]                       # Tide limit component loading
TI_CON = Data_Limits.iloc[2, 18]                        # Tide limit connection
TI_COM = Data_Limits.iloc[2, 19]                        # Tide limit commissioning

TideCheck = 1
MonthCheck = 0

MaxDuration = 13790                                      # Limit for maximum run time, in this case 1yr

if TideCheck == 1:
    TI_POS = 0
    TI_LOAD = 0
    TI_CON = 0
    TI_COM = 0

for size in range(1, 4):

    counter = int(size-1)
    N_WTB = Data_Farm.iloc[9+counter, 2]				# Number of turbines to be installed, depending on farm size

    if counter == 0:
        F_Size = "100MW wind farm"
    elif counter == 1:
        F_Size = "200MW wind farm"
    elif counter == 2:
        F_Size = "500MW wind farm"
    # elif counter == 3:
    #    F_Size = "1GW wind farm"

    for case in range(1, 3):

        if case == 1:                                                         # Shuttling case
            for option in range(1, 4):
                DurScenario = int(Data_Scenario.iloc[option, 1])            # 0=Mean, 1= Shorter, 2=Longer

                for year in years:
                    months=['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11']

                    start_date = str(year) + '-05-01 10:00:00'              # starting on the first day of summer on the selected year

                    # %% Weather Data input
                    # Load the data for the current year
                    filename = f"C:/Users/floda/Google Drive/NTNU/MasterThesis/Logistics/Model/MetData/{year}.csv"
                    met_data = pd.read_csv(filename)

                    # Load the data for the current year
                    tide_filename = f"C:/Users/floda/Google Drive/NTNU/MasterThesis/Logistics/Model/MetData/tide_data_{year}.csv"
                    tide_data = pd.read_csv(tide_filename)

                    # Rename the columns
                    met_data.rename(columns={'time': 'datetime', 'rlat': 'Latitude',
                                             'rlon': 'Longitude', 'dd': 'WindDir',
                                             'ff': 'WindSpeed', 'hs': 'Hs',
                                             'projection_ob_tran': 'Projection_ob_tran',
                                             'thq': 'WaveDir',
                                             'tp': 'Tp'}, inplace=True)

                    # %% Starting parameter set up

                    ts = pd.to_datetime(start_date)  # creates a timestamp for the start of the year

                    start = (ts.dayofyear - 1) * 24 + ts.hour  # gives us the hour of the year.

                    # ---------Operation Characteristics -----

                    T_POS = Data_Operation.iloc[2, 2+DurScenario]		        # Positioning and jacking up
                    T_LOAD = Data_Operation.iloc[3, 2+DurScenario]				# Transfer of components onto jack-up
                    T_CON = Data_Operation.iloc[4, 2+DurScenario]			    # Connecting the floater to the moorings
                    T_TOW = Data_Operation.iloc[5, 2+DurScenario]			    # Integration operation time tower section
                    T_NAC = Data_Operation.iloc[6, 2+DurScenario]			    # Integration operation time nacelle
                    T_BLD = Data_Operation.iloc[7, 2+DurScenario]		        # Integration operation time blade
                    T_COM = Data_Operation.iloc[8, 2+DurScenario]			    # Commissioning of the floater


                    # ----- Operation steps -----

                    WTB_Installed = 0
                    TOTAL_TIME = 0

                    waiting_wtb = 0
                    waiting_pos = 0
                    waiting_load = 0
                    waiting_con = 0
                    waiting_tow = 0
                    waiting_nac = 0
                    waiting_blade = 0
                    waiting_com = 0
                    waiting_trans = 0
                    waiting_wind = 0
                    waiting_hs = 0
                    waiting_tp = 0
                    waiting_tide = 0
                    waiting_wave = 0
                    waiting_wind_wave = 0

                    DUR_POS = T_POS                                             # Step 1 Positioning and preloading

                    duration_pos = math.ceil(DUR_POS)  # calculate the duration of step 2 and 3 to find the length of the weather window we need to find

                    for i in range(0, len(met_data.datetime) - start):
                        if (met_data.loc[start+math.ceil(TOTAL_TIME):start+math.ceil(TOTAL_TIME)+duration_pos-1, ['Hs']].max().item() <= HS_POS) and (met_data.loc[start+math.ceil(TOTAL_TIME):start+math.ceil(TOTAL_TIME)+duration_pos-1, ['Tp']].max().item() <= TP_POS) and (tide_data.loc[start+math.ceil(TOTAL_TIME):start+math.ceil(TOTAL_TIME)+duration_pos-1, ['Tides']].max().item() >= TI_POS):
                            # print ('good weather window')
                            TOTAL_TIME = TOTAL_TIME + DUR_POS
                            break
                        else:
                            # print('bad weather window')
                            if tide_data.loc[start+math.ceil(TOTAL_TIME):start+math.ceil(TOTAL_TIME)+duration_pos-1, ['Tides']].max().item() < TI_POS:
                                waiting_tide = waiting_tide + 1
                            else:
                                waiting_wave = waiting_wave + 1
                            waiting_wtb = waiting_wtb + 1
                            TOTAL_TIME = TOTAL_TIME + 1
                            i = +1
                            waiting_pos = waiting_pos + 1
                        if TOTAL_TIME >= MaxDuration:
                            break

                    # print('time after positioning', TOTAL_TIME)


                    while WTB_Installed<N_WTB and TOTAL_TIME <= MaxDuration:									# Loop to run until all the desired number of turbines are installed


                        DUR_LOAD_COMP = T_LOAD*(N_TOW+N_BLADE/3+N_NAC) 		    # Step 2 Loading components on vessel from feeder
                        duration_load = math.ceil(DUR_LOAD_COMP)

                        for i in range(0, len(met_data.datetime) - start):
                            if (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_load - 1, ['Hs']].max().item() <= HS_LOAD) and (tide_data.loc[start+math.ceil(TOTAL_TIME):start+math.ceil(TOTAL_TIME)+duration_load-1, ['Tides']].max().item() >= TI_LOAD):
                                # print ('good weather window')
                                TOTAL_TIME = TOTAL_TIME + DUR_LOAD_COMP
                                break
                            else:
                                # print('bad weather window')
                                if tide_data.loc[
                                   start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_load - 1,
                                   ['Tides']].max().item() < TI_LOAD:
                                    waiting_tide = waiting_tide + 1
                                else:
                                    waiting_wave = waiting_wave + 1
                                waiting_wtb = waiting_wtb + 1
                                TOTAL_TIME = TOTAL_TIME + 1
                                i = +1
                                waiting_load = waiting_load + 1
                            if TOTAL_TIME >= MaxDuration:
                                break

                        # print("Loading complete")
                        # print("total time after loading",TOTAL_TIME)

                        DUR_CON = T_CON*N_MOOR			                        # Step 3 arrival of floater and connecting to moorings
                        duration_con = math.ceil(DUR_CON)

                        for i in range(0, len(met_data.datetime) - start):
                            if (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_con - 1, ['Hs']].max().item() <= HS_CON) and (tide_data.loc[start+math.ceil(TOTAL_TIME):start+math.ceil(TOTAL_TIME)+duration_con-1, ['Tides']].max().item() >= TI_CON):

                                # print ('good weather window')
                                TOTAL_TIME = TOTAL_TIME + DUR_CON
                                break
                            else:
                                # print('bad weather window')
                                if tide_data.loc[
                                   start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_con - 1,
                                   ['Tides']].max().item() < TI_CON:
                                    waiting_tide = waiting_tide + 1
                                else:
                                    waiting_wave = waiting_wave + 1
                                waiting_wtb = waiting_wtb + 1
                                TOTAL_TIME = TOTAL_TIME + 1
                                i = +1
                                waiting_con = waiting_con + 1
                        # print('total time after floater connection',TOTAL_TIME)
                            if TOTAL_TIME >= MaxDuration:
                                break

                        DUR_HOIST_TOW = N_TOW * T_TOW                       # Step 4 lifting and installing tower pieces
                        duration_tow = math.ceil(DUR_HOIST_TOW)
                        for i in range(0, len(met_data.datetime) - start):
                            if (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1, ['Hs']].max().item() <= HS_TOW) and (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,['WindSpeed']].max().item() <= WS_TOW) and (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,['Tp']].max().item() <= TP_TOW):
                                # print ('good weather window')
                                TOTAL_TIME = TOTAL_TIME + DUR_HOIST_TOW
                                break
                            else:
                                if met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1, ['WindSpeed']].max().item() > WS_TOW and (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1, ['Hs']].max().item() <= HS_TOW) and (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,['Tp']].max().item() <= TP_TOW):
                                    waiting_wind = waiting_wind + 1
                                elif met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1, ['WindSpeed']].max().item() <= WS_TOW and (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1, ['Hs']].max().item() > HS_TOW) or (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,['Tp']].max().item() > TP_TOW):
                                    waiting_wave = waiting_wave + 1
                                else:
                                    waiting_wind_wave = waiting_wind_wave + 1
                                # print('bad weather window')
                                waiting_wtb = waiting_wtb + 1
                                TOTAL_TIME = TOTAL_TIME + 1
                                i = +1
                                waiting_tow = waiting_tow + 1
                            if TOTAL_TIME >= MaxDuration:
                                break
                        # print('time after installing tower pieces for turbine',WTB_Installed+1,':',TOTAL_TIME)

                        DUR_HOIST_NAC = T_NAC						            # Step 5 lifting and installing nacelle
                        duration_nac = math.ceil(DUR_HOIST_NAC)
                        for i in range(0, len(met_data.datetime) - start):
                            if (met_data.loc[
                                start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                ['Hs']].max().item() <= HS_NAC) and (met_data.loc[
                                                                     start + math.ceil(TOTAL_TIME):start + math.ceil(
                                                                             TOTAL_TIME) + duration_nac - 1,
                                                                     ['WindSpeed']].max().item() <= WS_NAC) and (
                                    met_data.loc[
                                    start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                    ['Tp']].max().item() <= TP_NAC):
                                # print ('good weather window')
                                TOTAL_TIME = TOTAL_TIME + DUR_HOIST_NAC
                                break
                            else:
                                if met_data.loc[
                                   start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                   ['WindSpeed']].max().item() > WS_NAC and (met_data.loc[start + math.ceil(
                                        TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                                                             ['Hs']].max().item() <= HS_NAC) and (
                                        met_data.loc[
                                        start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                        ['Tp']].max().item() <= TP_NAC):
                                    waiting_wind = waiting_wind + 1
                                elif met_data.loc[
                                     start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                     ['WindSpeed']].max().item() <= WS_NAC and (met_data.loc[start + math.ceil(
                                        TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                                                                ['Hs']].max().item() > HS_NAC) or (
                                        met_data.loc[
                                        start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                        ['Tp']].max().item() > TP_NAC):
                                    waiting_wave = waiting_wave + 1
                                else:
                                    waiting_wind_wave = waiting_wind_wave + 1
                                # print('bad weather window')
                                waiting_wtb = waiting_wtb + 1
                                TOTAL_TIME = TOTAL_TIME + 1
                                i = +1
                                waiting_nac = waiting_nac + 1

                            if TOTAL_TIME >= MaxDuration:
                                break

                        # print('time after installing nacelle of turbine',WTB_Installed+1,':',TOTAL_TIME)

                        for blade in range(N_BLADE):
                            DUR_INST_BLADE = T_BLD		                    # Step 6 Lifting and installing blades
                            duration_bld = math.ceil(DUR_INST_BLADE)

                            for i in range(0, len(met_data.datetime) - start):
                                if (met_data.loc[
                                    start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                    ['Hs']].max().item() <= HS_BLADE) and (met_data.loc[
                                                                         start + math.ceil(TOTAL_TIME):start + math.ceil(
                                                                                 TOTAL_TIME) + duration_bld - 1,
                                                                         ['WindSpeed']].max().item() <= WS_BLADE) and (
                                        met_data.loc[
                                        start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                        ['Tp']].max().item() <= TP_BLADE):
                                    # print ('good weather window')
                                    TOTAL_TIME = TOTAL_TIME + DUR_INST_BLADE
                                    break
                                else:
                                    if met_data.loc[
                                       start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                       ['WindSpeed']].max().item() > WS_BLADE and (met_data.loc[start + math.ceil(
                                            TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                                                                 ['Hs']].max().item() <= HS_BLADE) and (
                                            met_data.loc[
                                            start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                            ['Tp']].max().item() <= TP_BLADE):
                                        waiting_wind = waiting_wind + 1
                                    elif met_data.loc[
                                         start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                         ['WindSpeed']].max().item() <= WS_BLADE and (met_data.loc[start + math.ceil(
                                            TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                                                                    ['Hs']].max().item() > HS_BLADE) or (
                                            met_data.loc[
                                            start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                            ['Tp']].max().item() > TP_BLADE):
                                        waiting_wave = waiting_wave + 1
                                    else:
                                        waiting_wind_wave = waiting_wind_wave + 1
                                    # print('bad weather window')
                                    waiting_wtb = waiting_wtb + 1
                                    TOTAL_TIME = TOTAL_TIME + 1
                                    i = +1
                                    waiting_blade = waiting_blade + 1
                            # print('time after installing blades for turbine',WTB_Installed+1, ':', TOTAL_TIME)
                                if TOTAL_TIME >= MaxDuration:
                                    break

                        DUR_COMMISSIONING = T_COM                               # Step 7 Commissioning the floater
                        duration_com=math.ceil(DUR_COMMISSIONING)
                        for i in range(0, len(met_data.datetime) - start):
                            if (met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_com - 1, ['Hs']].max().item() <= HS_COMM) and (tide_data.loc[start+math.ceil(TOTAL_TIME):start+math.ceil(TOTAL_TIME)+duration_com-1, ['Tides']].max().item() >= TI_COM):

                                # print ('good weather window')
                                TOTAL_TIME = TOTAL_TIME + DUR_COMMISSIONING
                                break
                            else:
                                # print('bad weather window')
                                if tide_data.loc[
                                   start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_com - 1,
                                   ['Tides']].max().item() < TI_COM:
                                    waiting_tide = waiting_tide + 1
                                else:
                                    waiting_wave = waiting_wave + 1
                                waiting_wtb = waiting_wtb + 1
                                TOTAL_TIME = TOTAL_TIME + 1
                                i = +1
                                waiting_com = waiting_com + 1
                            if TOTAL_TIME >= MaxDuration:
                                break

                        WTB_Installed = WTB_Installed+1
                    if TOTAL_TIME >= MaxDuration:

                        Amount = WTB_Installed / N_WTB * 100
                        print('Turbines installed after one year: ', WTB_Installed, '=', Amount,
                              '% of wind turbines')



                    T_TOT.loc[str(year), 'Scenario ' + str(option)] = math.ceil(TOTAL_TIME)
                    WAIT_TOT.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_wtb)
                    Waiting_position.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_pos)
                    Waiting_transfer.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_load)
                    Waiting_connect.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_con)
                    Waiting_tower.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_tow)
                    Waiting_nacelle.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_nac)
                    Waiting_blade.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_blade)
                    Waiting_transit.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_trans)
                    Waiting_wave.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_wave)
                    Waiting_wind.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_wind)
                    Waiting_commission.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_com)
                    Waiting_tide.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_tide)
                    Waiting_WindWave.loc[str(year), 'Scenario ' + str(option)] = math.ceil(waiting_wind_wave)

                    # %% Results
                    # ------ results-------

                    print(year, 'Scenario', str(option), 'Total time installation', math.ceil(TOTAL_TIME), 'hours =', math.ceil(TOTAL_TIME/24), 'days')
                    print(year, 'Scenario', str(option), 'Total waiting time', math.ceil(waiting_wtb), 'hours =', math.ceil(waiting_wtb/24), 'days')

                    TOTAL_COST = TOTAL_TIME * (
                            (CHT_J + CHT_B + 3 * CHT_T + CHT_CR*4 + CHT_CTV) / 24)  # Cost of installation of Turbines, Rental cost/hour

                    COST_TOT.loc[str(year), 'Scenario ' + str(option)] = math.ceil(TOTAL_COST)
                    print(year, 'Scenario', str(option), 'Total installation cost', math.ceil(TOTAL_COST),
                          'kDollars')
                    print('Completed farm installation')
                    print('   ')
                average_T_TOT = T_TOT.loc[:, 'Scenario ' + str(option)].mean()
                T_TOT.loc["Average (h)", 'Scenario ' + str(option)] = average_T_TOT

                average_WAIT_TOT = WAIT_TOT.loc[:, 'Scenario ' + str(option)].mean()
                WAIT_TOT.loc["Average (h)", 'Scenario ' + str(option)] = average_WAIT_TOT

                average_Waiting_position = Waiting_position.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_position.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_position

                average_Waiting_transfer = Waiting_transfer.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_transfer.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_transfer

                average_Waiting_connect = Waiting_connect.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_connect.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_connect

                average_Waiting_tower = Waiting_tower.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_tower.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_tower

                average_Waiting_nacelle = Waiting_nacelle.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_nacelle.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_nacelle

                average_Waiting_blade = Waiting_blade.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_blade.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_blade

                average_Waiting_transit = Waiting_transit.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_transit.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_transit

                average_Waiting_wave = Waiting_wave.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_wave.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_wave


                average_Waiting_wind = Waiting_wind.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_wind.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_wind

                average_Waiting_com = Waiting_commission.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_commission.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_com

                average_Waiting_tide = Waiting_tide.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_tide.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_tide

                average_Waiting_WindWave = Waiting_WindWave.loc[:, 'Scenario ' + str(option)].mean()
                Waiting_WindWave.loc["Average (h)", 'Scenario ' + str(option)] = average_Waiting_WindWave

                average_COST_TOT = COST_TOT.loc[:, 'Scenario ' + str(option)].mean()
                COST_TOT.loc["Average (h)", 'Scenario ' + str(option)] = average_COST_TOT

                days_av_T_TOT = T_TOT.loc[:, 'Scenario ' + str(option)].mean()/24
                T_TOT.loc["Average (days)", 'Scenario ' + str(option)] = days_av_T_TOT

                days_av_WAIT_TOT = WAIT_TOT.loc[:, 'Scenario ' + str(option)].mean()/24
                WAIT_TOT.loc["Average (days)", 'Scenario ' + str(option)] = days_av_WAIT_TOT

                days_av_Waiting_position = Waiting_position.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_position.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_position

                days_av_Waiting_transfer = Waiting_transfer.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_transfer.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_transfer

                days_av_Waiting_connect = Waiting_connect.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_connect.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_connect

                days_av_Waiting_tower = Waiting_tower.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_tower.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_tower

                days_av_Waiting_nacelle = Waiting_nacelle.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_nacelle.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_nacelle

                days_av_Waiting_blade = Waiting_blade.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_blade.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_blade

                days_av_Waiting_transit = Waiting_transit.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_transit.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_transit

                days_av_Waiting_wave = Waiting_wave.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_wave.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_wave

                days_av_Waiting_wind = Waiting_wind.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_wind.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_wind

                days_av_Waiting_com = Waiting_commission.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_commission.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_com

                days_av_Waiting_tide = Waiting_tide.loc[:, 'Scenario ' + str(option)].mean()/24
                Waiting_tide.loc["Average (days)", 'Scenario ' + str(option)] = days_av_Waiting_tide

                days_av_COST_TOT = COST_TOT.loc[:, 'Scenario ' + str(option)].mean()/24
                COST_TOT.loc["Average (days)", 'Scenario ' + str(option)] = days_av_COST_TOT

        else:
            for option in range(1, 4):
                DurScenario = int(Data_Scenario.iloc[option, 1])            # 0=Mean, 1= Shorter, 2=Longer

                for year in years:
                    start_date = str(year) + '-05-01 00:00:00'  # starting on the first day of summer on the selected year

                    # %% Weather Data input
                    # Load the data for the current year
                    filename = f"C:/Users/floda/Google Drive/NTNU/MasterThesis/Logistics/Model/MetData/{year}.csv"
                    met_data = pd.read_csv(filename)

                    # Load the data for the current year
                    trans_filename = f"C:/Users/floda/Google Drive/NTNU/MasterThesis/Logistics/Model/MetData/Transit_{year}.csv"
                    transit_data = pd.read_csv(filename)

                    # Load the data for the current year
                    tide_filename = f"C:/Users/floda/Google Drive/NTNU/MasterThesis/Logistics/Model/MetData/tide_data_{year}.csv"
                    tide_data = pd.read_csv(tide_filename)

                    # Rename the columns
                    met_data.rename(columns={'time': 'datetime', 'rlat': 'Latitude',
                                             'rlon': 'Longitude', 'dd': 'WindDir',
                                             'ff': 'WindSpeed', 'hs': 'Hs',
                                             'projection_ob_tran': 'Projection_ob_tran',
                                             'thq': 'WaveDir',
                                             'tp': 'Tp'}, inplace=True)

                    transit_data.rename(columns={'time': 'datetime', 'rlat': 'Latitude',
                                                 'rlon': 'Longitude', 'hs': 'Hs',
                                                 'projection_ob_tran': 'Projection_ob_tran',
                                                 'tp': 'Tp'}, inplace=True)

                    # %% Starting parameter set up

                    ts = pd.to_datetime(start_date)  # creates a timestamp for the start of the year

                    start = (ts.dayofyear - 1) * 24 + ts.hour  # gives us the hour of the year.
                    # ---------Operation Characteristics -----

                    T_POS = Data_Operation.iloc[2, 2+DurScenario]		        # Positioning and jacking up
                    T_LOAD = Data_Operation.iloc[3, 2+DurScenario]				# Transfer of components onto jack-up
                    T_CON = Data_Operation.iloc[4, 2+DurScenario]			    # Connecting the floater to the moorings
                    T_TOW = Data_Operation.iloc[5, 2+DurScenario]			    # Integration operation time tower section
                    T_NAC = Data_Operation.iloc[6, 2+DurScenario]			    # Integration operation time nacelle
                    T_BLD = Data_Operation.iloc[7, 2+DurScenario]		        # Integration operation time blade
                    T_COM = Data_Operation.iloc[8, 2+DurScenario]			    # Commissioning of the floater

                    # ----- Operation steps -----

                    WTB_Installed = 0
                    TOTAL_TIME = 0

                    waiting_wtb = 0
                    waiting_pos = 0
                    waiting_load = 0
                    waiting_con = 0
                    waiting_tow = 0
                    waiting_nac = 0
                    waiting_blade = 0
                    waiting_com = 0
                    waiting_trans = 0
                    waiting_wind = 0
                    waiting_wave = 0
                    waiting_tide = 0
                    waiting_wind_wave = 0

                    WTB_Onboard = 0
                    stock_WTB = N_WTB


                    while WTB_Installed < N_WTB and TOTAL_TIME <= MaxDuration:  # Loop to run until all the desired number of turbines are installed


                        if stock_WTB > CAP_WTB:                                 # Check if the stock at the port is sufficient to load vessel
                            WTB_Onboard = CAP_WTB                               # Number of turbines on board is loaded until vessel capacity is reached
                        else:
                            WTB_Onboard = stock_WTB                             # If stock level is too low load remaining turbines

                        stock_WTB = stock_WTB - WTB_Onboard                     # New stock level after loading

                        DUR_LOAD = WTB_Onboard * T_LOAD * (N_TOW+N_BLADE/3+N_NAC)  # Step 1 Loading turbines in port

                        TOTAL_TIME = TOTAL_TIME + DUR_LOAD
                        # print("Loading complete")
                        # print ("stock turbines",stock_WTB)
                        # print("turbine on deck after port",WTB_Onboard)
                        # print("Left port")
                        # print("total time after loading",TOTAL_TIME)

                        DUR_TRANS = PORT_DIS / TRANS_VEL                      # Step 2 transportation towards site
                        duration_transit = math.ceil(DUR_TRANS)
                        for i in range(0, len(transit_data.datetime) - start):
                            if transit_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_transit - 1, ['Hs']].max().item() <= HS_TRANS:
                                # print ('good weather window')
                                TOTAL_TIME = TOTAL_TIME + DUR_TRANS
                                break
                            else:
                                # print('bad weather window')
                                waiting_wave = waiting_wave + 1
                                waiting_wtb = waiting_wtb + 1
                                TOTAL_TIME = TOTAL_TIME + 1
                                i = +1
                                waiting_trans = waiting_trans + 1
                            if TOTAL_TIME >= MaxDuration:
                                break
                        # print("total time after transit",TOTAL_TIME)

                        while WTB_Onboard > 0:                                  # Loop to run until all turbines on board are installed

                            DUR_POS = T_POS                                     # Step 3 Positioning and preloading
                            duration_pos = math.ceil(
                                DUR_POS)

                            for i in range(0, len(met_data.datetime) - start):
                                if (met_data.loc[
                                    start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_pos - 1,
                                    ['Hs']].max().item() <= HS_POS) and (met_data.loc[start + math.ceil(
                                        TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_pos - 1,
                                                                         ['Tp']].max().item() <= TP_POS) and (
                                        tide_data.loc[
                                        start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_pos - 1,
                                        ['Tides']].max().item() >= TI_POS):
                                    # print ('good weather window')
                                    TOTAL_TIME = TOTAL_TIME + DUR_POS
                                    break
                                else:
                                    # print('bad weather window')
                                    if tide_data.loc[
                                       start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_pos - 1,
                                       ['Tides']].max().item() < TI_POS:
                                        waiting_tide = waiting_tide + 1
                                    else:
                                        waiting_wave = waiting_wave + 1
                                    waiting_wtb = waiting_wtb + 1
                                    TOTAL_TIME = TOTAL_TIME + 1
                                    i = +1
                                    waiting_pos = waiting_pos + 1
                                if TOTAL_TIME >= MaxDuration:
                                    break

                            DUR_CON = T_CON * N_MOOR                            # Step 4 arrival of floater and connecting to moorings
                            duration_con = math.ceil(DUR_CON)

                            for i in range(0, len(met_data.datetime) - start):
                                if (met_data.loc[
                                    start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_con - 1,
                                    ['Hs']].max().item() <= HS_CON) and (tide_data.loc[start + math.ceil(
                                        TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_con - 1,
                                                                         ['Tides']].max().item() >= TI_CON):

                                    # print ('good weather window')
                                    TOTAL_TIME = TOTAL_TIME + DUR_CON
                                    break
                                else:
                                    # print('bad weather window')
                                    if tide_data.loc[
                                       start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_con - 1,
                                       ['Tides']].max().item() < TI_CON:
                                        waiting_tide = waiting_tide + 1
                                    else:
                                        waiting_wave = waiting_wave + 1
                                    waiting_wtb = waiting_wtb + 1
                                    TOTAL_TIME = TOTAL_TIME + 1
                                    i = +1
                                    waiting_con = waiting_con + 1
                                if TOTAL_TIME >= MaxDuration:
                                    break
                            # print('total time after floater connection',TOTAL_TIME)


                            DUR_HOIST_TOW = N_TOW * T_TOW                       # Step 5 lifting and installing tower pieces
                            duration_tow = math.ceil(DUR_HOIST_TOW)
                            for i in range(0, len(met_data.datetime) - start):
                                if (met_data.loc[
                                    start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,
                                    ['Hs']].max().item() <= HS_TOW) and (met_data.loc[start + math.ceil(
                                        TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,
                                                                         ['WindSpeed']].max().item() <= WS_TOW) and (
                                        met_data.loc[
                                        start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,
                                        ['Tp']].max().item() <= TP_TOW):
                                    # print ('good weather window')
                                    TOTAL_TIME = TOTAL_TIME + DUR_HOIST_TOW
                                    break
                                else:
                                    if met_data.loc[
                                       start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,
                                       ['WindSpeed']].max().item() > WS_TOW and (met_data.loc[start + math.ceil(
                                            TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,
                                                                                 ['Hs']].max().item() <= HS_TOW) and (
                                            met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(
                                                    TOTAL_TIME) + duration_tow - 1, ['Tp']].max().item() <= TP_TOW):
                                        waiting_wind = waiting_wind + 1
                                    elif met_data.loc[
                                         start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,
                                         ['WindSpeed']].max().item() <= WS_TOW and (met_data.loc[start + math.ceil(
                                            TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_tow - 1,
                                                                                    ['Hs']].max().item() > HS_TOW) or (
                                            met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(
                                                    TOTAL_TIME) + duration_tow - 1, ['Tp']].max().item() > TP_TOW):
                                        waiting_wave = waiting_wave + 1
                                    else:
                                        waiting_wind_wave = waiting_wind_wave + 1
                                    # print('bad weather window')
                                    waiting_wtb = waiting_wtb + 1
                                    TOTAL_TIME = TOTAL_TIME + 1
                                    i = +1
                                    waiting_tow = waiting_tow + 1
                                if TOTAL_TIME >= MaxDuration:
                                    break

                            # print('time after installing tower pieces for turbine',WTB_Installed+1,':',TOTAL_TIME)

                            DUR_HOIST_NAC = T_NAC                                  # Step 6 lifting and installing nacelle
                            duration_nac = math.ceil(DUR_HOIST_NAC)
                            for i in range(0, len(met_data.datetime) - start):
                                if (met_data.loc[
                                    start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                    ['Hs']].max().item() <= HS_NAC) and (met_data.loc[start + math.ceil(
                                        TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                                                         ['WindSpeed']].max().item() <= WS_NAC) and (
                                        met_data.loc[
                                        start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                        ['Tp']].max().item() <= TP_NAC):
                                    # print ('good weather window')
                                    TOTAL_TIME = TOTAL_TIME + DUR_HOIST_NAC
                                    break
                                else:
                                    if met_data.loc[
                                       start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                       ['WindSpeed']].max().item() > WS_NAC and (met_data.loc[start + math.ceil(
                                            TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                                                                 ['Hs']].max().item() <= HS_NAC) and (
                                            met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(
                                                    TOTAL_TIME) + duration_nac - 1, ['Tp']].max().item() <= TP_NAC):
                                        waiting_wind = waiting_wind + 1
                                    elif met_data.loc[
                                         start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                         ['WindSpeed']].max().item() <= WS_NAC and (met_data.loc[start + math.ceil(
                                            TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_nac - 1,
                                                                                    ['Hs']].max().item() > HS_NAC) or (
                                            met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(
                                                    TOTAL_TIME) + duration_nac - 1, ['Tp']].max().item() > TP_NAC):
                                        waiting_wave = waiting_wave + 1
                                    else:
                                        waiting_wind_wave = waiting_wind_wave + 1
                                    # print('bad weather window')
                                    waiting_wtb = waiting_wtb + 1
                                    TOTAL_TIME = TOTAL_TIME + 1
                                    i = +1
                                    waiting_nac = waiting_nac + 1
                                if TOTAL_TIME >= MaxDuration:
                                    break

                            # print('time after installing nacelle of turbine',WTB_Installed+1,':',TOTAL_TIME)

                            for blade in range(N_BLADE):
                                DUR_INST_BLADE = T_BLD                        # Step 7 Lifting and installing blades
                                duration_bld = math.ceil(DUR_INST_BLADE)

                                for i in range(0, len(met_data.datetime) - start):
                                    if (met_data.loc[
                                        start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                        ['Hs']].max().item() <= HS_BLADE) and (met_data.loc[start + math.ceil(
                                            TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                                                             ['WindSpeed']].max().item() <= WS_BLADE) and (
                                            met_data.loc[
                                            start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                            ['Tp']].max().item() <= TP_BLADE):
                                        # print ('good weather window')
                                        TOTAL_TIME = TOTAL_TIME + DUR_INST_BLADE
                                        break
                                    else:
                                        if met_data.loc[
                                           start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                           ['WindSpeed']].max().item() > WS_BLADE and (met_data.loc[start + math.ceil(
                                                TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                                                                     ['Hs']].max().item() <= HS_BLADE) and (
                                                met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(
                                                        TOTAL_TIME) + duration_bld - 1, ['Tp']].max().item() <= TP_BLADE):
                                            waiting_wind = waiting_wind + 1
                                        elif met_data.loc[
                                             start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                             ['WindSpeed']].max().item() <= WS_BLADE and (met_data.loc[start + math.ceil(
                                                TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_bld - 1,
                                                                                        ['Hs']].max().item() > HS_BLADE) or (
                                                met_data.loc[start + math.ceil(TOTAL_TIME):start + math.ceil(
                                                        TOTAL_TIME) + duration_bld - 1, ['Tp']].max().item() > TP_BLADE):
                                            waiting_wave = waiting_wave + 1
                                        else:
                                            waiting_wind_wave = waiting_wind_wave + 1
                                        # print('bad weather window')
                                        waiting_wtb = waiting_wtb + 1
                                        TOTAL_TIME = TOTAL_TIME + 1
                                        i = +1
                                        waiting_blade = waiting_blade + 1
                                    if TOTAL_TIME >= MaxDuration:
                                        break
                            # print('time after installing blades for turbine',WTB_Installed+1, ':', TOTAL_TIME)

                            DUR_COMMISSIONING = T_COM                                   # Step 8 Commissioning the floater
                            duration_com = math.ceil(DUR_COMMISSIONING)
                            for i in range(0, len(met_data.datetime) - start):
                                if (met_data.loc[
                                    start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_com - 1,
                                    ['Hs']].max().item() <= HS_COMM) and (tide_data.loc[start + math.ceil(
                                        TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_com - 1,
                                                                          ['Tides']].max().item() >= TI_COM):

                                    # print ('good weather window')
                                    TOTAL_TIME = TOTAL_TIME + DUR_COMMISSIONING
                                    break
                                else:
                                    # print('bad weather window')
                                    if tide_data.loc[
                                       start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_com - 1,
                                       ['Tides']].max().item() < TI_COM:
                                        waiting_tide = waiting_tide + 1
                                    else:
                                        waiting_wave = waiting_wave + 1
                                    waiting_wtb = waiting_wtb + 1
                                    TOTAL_TIME = TOTAL_TIME + 1
                                    i = +1
                                    waiting_com = waiting_com + 1
                                if TOTAL_TIME >= MaxDuration:
                                    break

                            WTB_Installed = WTB_Installed + 1
                            #print('WTB_Onboard',WTB_Onboard)
                            WTB_Onboard = WTB_Onboard - 1



                        else:
                            DUR_JD = T_POS/2  # Jacking down
                            TOTAL_TIME = TOTAL_TIME + DUR_JD
                            # print('time after positioning', TOTAL_TIME)

                            DUR_TRANS = PORT_DIS / TRANS_VEL  # Step return to port
                            duration_transit = math.ceil(DUR_TRANS)
                            for i in range(0, len(transit_data.datetime) - start):
                                if (transit_data.loc[
                                    start + math.ceil(TOTAL_TIME):start + math.ceil(TOTAL_TIME) + duration_transit - 1,
                                    ['Hs']].max().item() <= HS_TRANS):
                                    # print ('good weather window')
                                    TOTAL_TIME = TOTAL_TIME + DUR_TRANS
                                    break
                                else:
                                    # print('bad weather window')
                                    waiting_wave = waiting_wave + 1
                                    waiting_wtb = waiting_wtb + 1
                                    TOTAL_TIME = TOTAL_TIME + 1
                                    i = +1
                                    waiting_trans = waiting_trans + 1
                                if TOTAL_TIME >= MaxDuration:
                                    break

                    if TOTAL_TIME >= MaxDuration:

                        Amount=WTB_Installed/N_WTB * 100
                        print('Turbines installed after one year: ', WTB_Installed, '=', Amount, '% of wind turbines')
                        # Exit the loop if TOTAL_TIME exceeds 8760 hour
                        # print("total time after transit",TOTAL_TIME)
                        # print('return to port')

                    T_TOT.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(TOTAL_TIME)
                    WAIT_TOT.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_wtb)
                    Waiting_position.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_pos)
                    Waiting_transfer.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_load)
                    Waiting_connect.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_con)
                    Waiting_tower.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_tow)
                    Waiting_nacelle.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_nac)
                    Waiting_blade.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_blade)
                    Waiting_transit.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_trans)
                    Waiting_commission.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_com)
                    Waiting_wave.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_wave)
                    Waiting_wind.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_wind)
                    Waiting_tide.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_tide)
                    Waiting_WindWave.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(waiting_wind_wave)

                    # %% Results
                    # ------ results-------

                    print(year, 'Scenario', str(option+3), 'Total time installation', math.ceil(TOTAL_TIME), 'hours =', math.ceil(TOTAL_TIME/24), 'days')
                    print(year, 'Scenario', str(option+3), 'Total waiting time', math.ceil(waiting_wtb), 'hours =', math.ceil(waiting_wtb/24), 'days')

                    TOTAL_COST = TOTAL_TIME * (
                                (CHT_J + 2 * CHT_T + CHT_CR*4 + CHT_CTV) / 24)  # Cost of installation of Turbines, Rental cost/hour

                    COST_TOT.loc[str(year), 'Scenario ' + str(option+3)] = math.ceil(TOTAL_COST)

                    print(year, 'Scenario', str(option+3), 'Total installation cost', math.ceil(TOTAL_COST), 'kDollars')
                    print('Completed farm installation')
                    print('   ')
                average_T_TOT = T_TOT.loc[:, 'Scenario ' + str(option+3)].mean()
                T_TOT.loc["Average (h)", 'Scenario ' + str(option+3)] = average_T_TOT

                average_WAIT_TOT = WAIT_TOT.loc[:, 'Scenario ' + str(option+3)].mean()
                WAIT_TOT.loc["Average (h)", 'Scenario ' + str(option+3)] = average_WAIT_TOT

                average_Waiting_position = Waiting_position.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_position.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_position

                average_Waiting_transfer = Waiting_transfer.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_transfer.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_transfer

                average_Waiting_connect = Waiting_connect.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_connect.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_connect

                average_Waiting_tower = Waiting_tower.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_tower.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_tower

                average_Waiting_nacelle = Waiting_nacelle.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_nacelle.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_nacelle

                average_Waiting_blade = Waiting_blade.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_blade.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_blade

                average_Waiting_transit = Waiting_transit.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_transit.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_transit

                average_Waiting_wave = Waiting_wave.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_wave.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_wave

                average_Waiting_wind = Waiting_wind.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_wind.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_wind

                average_Waiting_com = Waiting_commission.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_commission.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_com

                average_Waiting_WindWave = Waiting_WindWave.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_WindWave.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_WindWave

                average_Waiting_tide = Waiting_tide.loc[:, 'Scenario ' + str(option+3)].mean()
                Waiting_tide.loc["Average (h)", 'Scenario ' + str(option+3)] = average_Waiting_tide

                average_COST_TOT = COST_TOT.loc[:, 'Scenario ' + str(option+3)].mean()
                COST_TOT.loc["Average (h)", 'Scenario ' + str(option+3)] = average_COST_TOT

                days_av_T_TOT = T_TOT.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                T_TOT.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_T_TOT

                days_av_WAIT_TOT = WAIT_TOT.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                WAIT_TOT.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_WAIT_TOT

                days_av_Waiting_position = Waiting_position.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_position.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_position

                days_av_Waiting_transfer = Waiting_transfer.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_transfer.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_transfer

                days_av_Waiting_connect = Waiting_connect.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_connect.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_connect

                days_av_Waiting_tower = Waiting_tower.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_tower.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_tower

                days_av_Waiting_nacelle = Waiting_nacelle.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_nacelle.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_nacelle

                days_av_Waiting_blade = Waiting_blade.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_blade.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_blade

                days_av_Waiting_transit = Waiting_transit.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_transit.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_transit

                days_av_Waiting_hs = Waiting_wave.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_wave.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_wave

                days_av_Waiting_wind = Waiting_wind.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_wind.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_wind

                days_av_Waiting_com = Waiting_commission.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_commission.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_com

                days_av_Waiting_tide = Waiting_tide.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                Waiting_tide.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_Waiting_tide

                days_av_COST_TOT = COST_TOT.loc[:, 'Scenario ' + str(option+3)].mean() / 24
                COST_TOT.loc["Average (days)", 'Scenario ' + str(option+3)] = days_av_COST_TOT

    # Create a Pandas Excel writer using XlsxWriter as the engine
    filename = F_Size + ' Results.xlsx'
    #filename = F_Size + ' Results Low.xlsx'
    #filename = F_Size + ' Results High.xlsx'

    writer = pd.ExcelWriter(filename, engine='xlsxwriter')

    # Write each dataframe to a different worksheet
    T_TOT.to_excel(writer, sheet_name='T_TOT')
    COST_TOT.to_excel(writer, sheet_name='COST_TOT')
    WAIT_TOT.to_excel(writer, sheet_name='WAIT_TOT')
    Waiting_position.to_excel(writer, sheet_name='Waiting_position')
    Waiting_transfer.to_excel(writer, sheet_name='Waiting_transfer')
    Waiting_connect.to_excel(writer, sheet_name='Waiting_connect')
    Waiting_tower.to_excel(writer, sheet_name='Waiting_tower')
    Waiting_nacelle.to_excel(writer, sheet_name='Waiting_nacelle')
    Waiting_blade.to_excel(writer, sheet_name='Waiting_blade')
    Waiting_commission.to_excel(writer, sheet_name='Waiting_commission')
    Waiting_transit.to_excel(writer, sheet_name='Waiting_transit')
    Waiting_wave.to_excel(writer, sheet_name='Waiting_wave')
    Waiting_wind.to_excel(writer, sheet_name='Waiting_wind')
    Waiting_tide.to_excel(writer, sheet_name='Waiting_tide')
    Waiting_WindWave.to_excel(writer, sheet_name='Waiting_WindWave')

    # Close the Pandas Excel writer and output the Excel file.
    writer.save()
