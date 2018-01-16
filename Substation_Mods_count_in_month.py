# -*- coding: utf-8 -*-
"""
Created on Tue Jan 16 19:36:27 2018

@author: Nagasudhir
"""

# get the list of all csv files -- done
# read each one into a dataframe and remove rows with Nan values -- done
# attach all the csv dataframes -- done
# get the unique ss_ids -- done
# for each ss_id plot time vs freq in a subplot
# done

# import all the packages towork with
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.dates as mdates


csvs_path = 'C:\\Users\\Nagasudhir\\Documents\\Python Projects\\Mods In a Month\\1-6-1-7\\'
dest_path = ['C:\\Users\\Nagasudhir\\Documents\\Python Projects\\Mods In a Month\\output_images\\1-6-1-7\\']
report_prefix = 'ss_mod_scatter_plot'
src_format = 'csv'

# get the list of all csv files
filesList = []
reqCols = ['STARTDATE', 'SubstationId', 'DeviceType', 'DeviceId', 'MeasurementId', 'Mode', 'ModeMin', 'ModeMax', 'Frequency:PDX1', 'Frequency:PDX1:Quality']
finalDf = pd.DataFrame(columns=reqCols)
for i in os.listdir(csvs_path):
    if os.path.isfile(os.path.join(csvs_path,i)) and i.endswith('.' + src_format):
        df = pd.read_csv(os.path.join(csvs_path,i),usecols=reqCols)
        df = df[~np.isnan(df['Frequency:PDX1'])]
        finalDf = finalDf.append(df)
        filesList.append(i)

# finalize the dataframe for plotting
plottingDf = finalDf.drop_duplicates(subset=['STARTDATE', 'SubstationId', 'Frequency:PDX1'])

# get the unique ss_ids
ss_names = plottingDf['SubstationId'].unique().tolist()

num_subplt_cols = 3
num_subplt_rows = int(np.ceil(len(ss_names)/(num_subplt_cols*1.0)))

# plt.style.use('ggplot')
fig, ax_array = plt.subplots(num_subplt_rows, num_subplt_cols, sharex=True, sharey=True)
ax_array = fig.get_axes()
# Get current size
fig_size = plt.rcParams["figure.figsize"]
# Set figure height in inches
fig_size[0] = 5*num_subplt_rows
# Set figure width in inches
fig_size[1] = 6*num_subplt_cols
plt.rcParams["figure.figsize"] = fig_size
# Set Title of figure
plt.gcf().suptitle('Mode frequencies found in a time period for different Substations in a month', fontsize=20)

for ss_counter, ss_name in enumerate(ss_names):
    # set the subplot title
    ax = ax_array[ss_counter]
    ax.plot(pd.to_datetime(plottingDf[plottingDf['SubstationId']==ss_name]['STARTDATE']), plottingDf[plottingDf['SubstationId']==ss_name]['Frequency:PDX1'], marker=".",  markersize=2, linewidth=0,c='r')
    ax.set_title("{}".format(ss_name), fontsize = 14)
    for label in ax.get_xticklabels() + ax.get_yticklabels():
        label.set_visible(True)
    # set the major and minor tick locations and formats
    # https://matplotlib.org/examples/api/date_demo.html
    
# adjust the subplots to accommodate the labels, title etc by using the tight layout command http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.tight_layout
plt.tight_layout(w_pad = 0.2, pad = 0.35)
# rotates and right aligns the x labels, and moves the bottom of the
# axes up to make room for them
fig.autofmt_xdate()
# explicitly set the top margin to accommodate the title
fig.subplots_adjust(top=0.85)
fig.savefig('temp.png')

