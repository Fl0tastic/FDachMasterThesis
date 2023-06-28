# -*- coding: utf-8 -*-
# %% File reading
"""
Created on Wed Dec  1 15:15:30 2021

@author: Florian Dach, Hugo Boer
"""
import pandas as pd  
import math

loc="Vessel Data Talbot.xls"
loc2="Farm Data Talbot.xls"


Data_Vessel = pd.read_excel(loc, sheet_name='Vessel')	      # Vessel data sheet
Data_Operation = pd.read_excel(loc, sheet_name='Operation')   # Operation data sheet
Data_Farm = pd.read_excel(loc2) 		                      # Farm data sheet
Data_Scenario = pd.read_excel(loc, sheet_name='Scenarios')

T_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
COST_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
T_POS_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
T_LOAD_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
T_CON_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
T_TOW_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
T_NAC_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
T_BLADE_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
T_COM_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
T_TRANS_TOT = pd.DataFrame(columns=['Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5', 'Scenario 6'], index=["Calm"])
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

        if case == 1:                                                       # Feeder case
            for option in range(1, 4):
                DurScenario = int(Data_Scenario.iloc[option, 1])            # 0=Mean, 1= Shorter, 2=Longer

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


                DUR_POS = T_POS                                             # Step 1 Positioning and preloading
                TOTAL_TIME = TOTAL_TIME + DUR_POS
                # print('time after positioning', TOTAL_TIME)


                while WTB_Installed<N_WTB:									# Loop to run until all the desired number of turbines are installed

                    DUR_LOAD_COMP = T_LOAD*(N_TOW+N_BLADE/3+N_NAC) 		    # Step 2 Loading components on vessel from feeder
                    TOTAL_TIME = TOTAL_TIME + DUR_LOAD_COMP
                    #print("Loading complete")
                    #print("total time after loading",TOTAL_TIME)

                    DUR_CON = T_CON*N_MOOR			                        # Step 3 arrival of floater and connecting to moorings
                    TOTAL_TIME = TOTAL_TIME + DUR_CON
                    #print('total time after floater connection',TOTAL_TIME)

                    DUR_HOIST_TOW = N_TOW*T_TOW 							# Step 4 lifting and installing tower pieces
                    TOTAL_TIME = TOTAL_TIME + DUR_HOIST_TOW
                    #print('time after installing tower pieces for turbine',WTB_Installed+1,':',TOTAL_TIME)

                    DUR_HOIST_NAC = T_NAC						            # Step 5 lifting and installing nacelle
                    TOTAL_TIME = TOTAL_TIME +DUR_HOIST_NAC
                    #print('time after installing nacelle of turbine',WTB_Installed+1,':',TOTAL_TIME)

                    for blade in range(N_BLADE):
                        DUR_INST_BLADE = T_BLD  # Step 6 Lifting and installing blades
                        TOTAL_TIME =TOTAL_TIME+DUR_INST_BLADE
                    #print('time after installing blades for turbine',WTB_Installed+1, ':', TOTAL_TIME)

                    DUR_COMMISSIONING = T_COM                               # Step 7 Commissioning the floater
                    TOTAL_TIME = TOTAL_TIME + DUR_COMMISSIONING
                    # print('time after installing blades for turbine',WTB_Installed+1, ':', TOTAL_TIME)

                    DUR_TRANS=0

                    WTB_Installed = WTB_Installed+1
                    #print('time after installing turbine',WTB_Installed,':',TOTAL_TIME)
                #print('Turbine installation completed')



                #%% Results
                #------ results-------
                print('   ')
                print(F_Size,'Case',case,'Scenario', DurScenario, 'Total time installation turbines', math.ceil(TOTAL_TIME), 'hours =', math.ceil(TOTAL_TIME/24), 'days')

                TOTAL_COST = TOTAL_TIME * ((CHT_J + CHT_B + 3 * CHT_T + CHT_CR * 4 + CHT_CTV) / 24)  # Cost of installation of Turbines, Rental cost/hour

                T_POS_TOTAL = DUR_POS
                T_LOAD_TOTAL = DUR_LOAD_COMP * N_WTB
                T_CON_TOTAL = DUR_CON * N_WTB
                T_TOW_TOTAL = DUR_HOIST_TOW * N_WTB
                T_NAC_TOTAL = DUR_HOIST_NAC * N_WTB
                T_BLADE_TOTAL = DUR_INST_BLADE * N_WTB
                T_COM_TOTAL = DUR_COMMISSIONING * N_WTB
                T_TRANS_TOTAL = DUR_TRANS * N_WTB

                print('   ')
                print(F_Size, 'Case', case, 'Scenario', DurScenario, 'Total Cost of installation farm',
                      math.ceil(TOTAL_COST), 'k €')
                T_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(TOTAL_TIME)
                COST_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(TOTAL_COST)
                T_POS_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(T_POS_TOTAL)
                T_LOAD_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(T_LOAD_TOTAL)
                T_CON_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(T_CON_TOTAL)
                T_TOW_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(T_TOW_TOTAL)
                T_NAC_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(T_NAC_TOTAL)
                T_BLADE_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(T_BLADE_TOTAL)
                T_COM_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(T_COM_TOTAL)
                T_TRANS_TOT.loc['Calm', 'Scenario ' + str(option)] = math.ceil(T_TRANS_TOTAL)


        else:                                                               # Shuttling case
            for option in range(1, 4):
                DurScenario = int(Data_Scenario.iloc[option, 1])  # 0=Mean, 1= Shorter, 2=Longer

                # ---------Operation Characteristics -----

                T_POS = Data_Operation.iloc[2, 2 + DurScenario]  # Positioning and jacking up
                T_LOAD = Data_Operation.iloc[3, 2 + DurScenario]  # Transfer of components onto jack-up
                T_CON = Data_Operation.iloc[4, 2 + DurScenario]  # Connecting the floater to the moorings
                T_TOW = Data_Operation.iloc[5, 2 + DurScenario]  # Integration operation time tower section
                T_NAC = Data_Operation.iloc[6, 2 + DurScenario]  # Integration operation time nacelle
                T_BLD = Data_Operation.iloc[7, 2 + DurScenario]  # Integration operation time blade
                T_COM = Data_Operation.iloc[8, 2 + DurScenario]  # Commissioning of the floater

                WTB_Installed = 0
                WTB_Onboard = 0
                T_LOAD_TOTAL = 0
                T_POS_TOTAL = 0
                TOTAL_TIME = 0
                stock_WTB = N_WTB


                while WTB_Installed < N_WTB:  # Loop to run until all the desired number of turbines are installed

                    if stock_WTB > CAP_WTB:                                 # Check if the stock at the port is sufficient to load vessel
                        WTB_Onboard = CAP_WTB                               # Number of turbines on board is loaded until vessel capacity is reached
                    else:
                        WTB_Onboard = stock_WTB                             # If stock level is too low load remaining turbines
                    stock_WTB = stock_WTB - WTB_Onboard                     # New stock level after loading

                    DUR_LOAD = WTB_Onboard * T_LOAD * (N_TOW+N_BLADE/3+N_NAC)  # Step 1 Loading turbines in port
                    T_LOAD_TOTAL = T_LOAD_TOTAL + DUR_LOAD

                    TOTAL_TIME = TOTAL_TIME + DUR_LOAD
                    # print("Loading complete")
                    # print ("stock turbines",stock_WTB)
                    # print("turbine on deck after port",WTB_Onboard)
                    # print("Left port")
                    # print("total time after loading",TOTAL_TIME)

                    DUR_TRANS = PORT_DIS / TRANS_VEL                      # Step 2 transportation towards site

                    TOTAL_TIME = TOTAL_TIME + DUR_TRANS
                    # print("total time after transit",TOTAL_TIME)

                    DUR_POS = T_POS                                       # Step 3 Positioning and preloading
                    T_POS_TOTAL = T_POS_TOTAL + DUR_POS
                    TOTAL_TIME = TOTAL_TIME + DUR_POS
                    # print('time after positioning', TOTAL_TIME)

                    while WTB_Onboard > 0:                                  # Loop to run until all turbines on board are installed

                        DUR_CON = T_CON * N_MOOR                            # Step 4 arrival of floater and connecting to moorings
                        TOTAL_TIME = TOTAL_TIME + DUR_CON
                        # print('total time after floater connection',TOTAL_TIME)

                        DUR_HOIST_TOW = N_TOW * T_TOW                       # Step 5 lifting and installing tower pieces
                        TOTAL_TIME = TOTAL_TIME + DUR_HOIST_TOW
                        # print('time after installing tower pieces for turbine',WTB_Installed+1,':',TOTAL_TIME)

                        DUR_HOIST_NAC = T_NAC                               # Step 6 lifting and installing nacelle
                        TOTAL_TIME = TOTAL_TIME + DUR_HOIST_NAC
                        # print('time after installing nacelle of turbine',WTB_Installed+1,':',TOTAL_TIME)

                        DUR_INST_BLADE = N_BLADE * T_BLD                    # Step 7 Lifting and installing blades
                        TOTAL_TIME = TOTAL_TIME + DUR_INST_BLADE
                        # print('time after installing blades for turbine',WTB_Installed+1, ':', TOTAL_TIME)

                        DUR_COMMISSIONING = T_COM                           # Step 8 Commissioning the floater
                        TOTAL_TIME = TOTAL_TIME + DUR_COMMISSIONING
                        # print('time after installing blades for turbine',WTB_Installed+1, ':', TOTAL_TIME)

                        WTB_Installed = WTB_Installed + 1
                        WTB_Onboard = WTB_Onboard - 1
                        # print('time after installing turbine',WTB_Installed,':',TOTAL_TIME_WTB)


                    else:
                        DUR_JD = T_POS/2  # Jacking down
                        TOTAL_TIME = TOTAL_TIME + DUR_JD
                        T_POS_TOTAL = T_POS_TOTAL + DUR_JD
                        # print('time after positioning', TOTAL_TIME)

                        DUR_TRANS = PORT_DIS / TRANS_VEL  # Step return to port
                        TOTAL_TIME = TOTAL_TIME + DUR_TRANS
                        # print('return to port')

                #%% Results
                #------ results-------
                print('   ')
                print(F_Size,'Case',case,'Scenario', DurScenario, 'Total time installation turbines', math.ceil(TOTAL_TIME), 'hours =', math.ceil(TOTAL_TIME/24), 'days')

                TOTAL_COST = TOTAL_TIME * ((CHT_J + 2 * CHT_T + CHT_CR * 4 + CHT_CTV) / 24)  # Cost of installation of Turbines, Rental cost/hour




                T_CON_TOTAL = DUR_CON * N_WTB
                T_TOW_TOTAL = DUR_HOIST_TOW * N_WTB
                T_NAC_TOTAL = DUR_HOIST_NAC * N_WTB
                T_BLADE_TOTAL = DUR_INST_BLADE * N_WTB
                T_COM_TOTAL = DUR_COMMISSIONING * N_WTB
                T_TRANS_TOTAL = DUR_TRANS * N_WTB

                print('   ')
                print(F_Size,'Case',case,'Scenario', DurScenario,'Total Cost of installation farm', math.ceil(TOTAL_COST), 'k €')
                T_TOT.loc['Calm','Scenario ' + str(option+3)] = math.ceil(TOTAL_TIME)
                COST_TOT.loc['Calm','Scenario ' + str(option+3)] = math.ceil(TOTAL_COST)
                T_POS_TOT.loc['Calm', 'Scenario ' + str(option + 3)] = math.ceil(T_POS_TOTAL)
                T_LOAD_TOT.loc['Calm', 'Scenario ' + str(option + 3)] = math.ceil(T_LOAD_TOTAL)
                T_CON_TOT.loc['Calm', 'Scenario ' + str(option + 3)] = math.ceil(T_CON_TOTAL)
                T_TOW_TOT.loc['Calm', 'Scenario ' + str(option + 3)] = math.ceil(T_TOW_TOTAL)
                T_NAC_TOT.loc['Calm', 'Scenario ' + str(option + 3)] = math.ceil(T_NAC_TOTAL)
                T_BLADE_TOT.loc['Calm', 'Scenario ' + str(option + 3)] = math.ceil(T_BLADE_TOTAL)
                T_COM_TOT.loc['Calm', 'Scenario ' + str(option + 3)] = math.ceil(T_COM_TOTAL)
                T_TRANS_TOT.loc['Calm', 'Scenario ' + str(option + 3)] = math.ceil(T_TRANS_TOTAL)

    filename = F_Size + ' Calm Weather Results.xlsx'
    writer = pd.ExcelWriter(filename, engine='xlsxwriter')

    # Write each dataframe to a different worksheet
    T_TOT.to_excel(writer, sheet_name='T_TOT')
    COST_TOT.to_excel(writer, sheet_name='COST_TOT')
    T_POS_TOT.to_excel(writer, sheet_name='T_POS_TOT')
    T_LOAD_TOT.to_excel(writer, sheet_name='T_LOAD_TOT')
    T_CON_TOT.to_excel(writer, sheet_name='T_CON_TOT')
    T_TOW_TOT.to_excel(writer, sheet_name='T_TOW_TOT')
    T_NAC_TOT.to_excel(writer, sheet_name='T_NAC_TOT')
    T_BLADE_TOT.to_excel(writer, sheet_name='T_BLADE_TOT')
    T_COM_TOT.to_excel(writer, sheet_name='T_COM_TOT')
    T_TRANS_TOT.to_excel(writer, sheet_name='T_TRANS_TOT')

    # Close the Pandas Excel writer and output the Excel file.
    writer.save()

