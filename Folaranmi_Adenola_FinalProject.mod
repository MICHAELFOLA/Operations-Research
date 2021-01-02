 int N=...;  //Total number of aircraft
 int Marr=...; // Number of aircraft arriving to VRA
 int Mdep=...;// Number of aircraft departing VRA

 
 range arr_AC=1..Marr; // Range of arriving aircraft
 range all_AC=1..N; // Range for all aircraft (arriving and departing)
 		
 float Td[all_AC]=...;  //Desired departure time of aircraft
 float Tt[arr_AC]=...;  //Time time to VRA
 float TS[all_AC,all_AC]=...; //Separation time between aircraft
 float Ca[all_AC]=...; // Cost of advancing departure time
 float Cd[all_AC]=...; // Cost of delaying departure time
 float Cs[arr_AC]=...; // Cost of shortening travel time
 float Cl[arr_AC]=...;  // Cost of lengthening travel time
 
 dvar float+ Tdadv[all_AC];
 dvar float+ Tddelay[all_AC];
 dvar float+ Ttshorten[arr_AC];
 dvar float+ Ttlenghten[arr_AC];
 dvar float+ Tactarr[arr_AC];
 dvar float+ Tactdep[all_AC];
 dvar float+ Costdep[all_AC];
dvar float+ Costarr[all_AC];
 
 //obejective function
 //minimize sum (i in all_AC, j in all_AC) Ca[i]*Tdadv[i] + Cd[i]*Tddelay[i] + Cs[j]*Ttshorten[j] + Cl[j]*Ttlenghten[j];
 minimize sum (i in all_AC) Costarr[i] + Costdep[2];
 subject to {
 //Cost related constraints
 forall (i in arr_AC)
   Costarr[i] == (Cs[i]*Ttshorten[i] + Cl[i]*Ttlenghten[i]);
 forall (j in all_AC)
   Costdep[j] == (Ca[j]*Tdadv[j] + Cd[j]*Tddelay[j]);
 
   
 //The acutal times of arrival and delay
   forall (i in arr_AC)
     Tactarr[i] == Td[i] + Tt[i]  + Ttlenghten[i] - Ttshorten[i];
   forall (j in all_AC)
     Tactdep[j] == Td[j] + Tddelay[j] - Tdadv[j];
     
  //Constraints restricting ALL departure times and arrival times to be between 0 and 1440
  forall (i in arr_AC)
    Tactarr[i] <= 1440;
  forall (j in all_AC)
    Tactdep[j] <= 1140;
    
    //For the travel time to be within +/-25% of the nominal travel time
  forall (i in arr_AC)
    Tactarr[i] <= 1.25*(Tactarr[i] == Td[i] + Tt[i]  + Ttlenghten[i]- Ttshorten[i]);
  forall (i in arr_AC)
    Tactarr[i]>= 0.75*(Td[i] + Tt[i] + Ttlenghten[i]- Ttshorten[i]); //== Td[i]+Tddelay[i]-Tdadv[i]);
    
  //Checking relationships between safety constraints, actual arrival time and actual departure time
  forall (i in arr_AC, j in all_AC)
    (Tactarr[i] <= Tactdep[j]) => (Tactarr[i] + TS[i,j] <=Tactdep[j]);
  forall (i in arr_AC)
    forall (m in arr_AC)
      (Tactarr[i] <= Tactarr[m]) => (Tactarr[i] + TS[i,m] <= Tactarr[m]);
  forall (j in all_AC)
    forall (i in arr_AC)
      (Tactdep[j] <= Tactarr[i]) => (Tactdep[j] + TS[j,i] <= Tactarr[i]);
  forall (j in all_AC)
    forall (n in all_AC)
      (Tactdep[j] <= Tactdep[n]) => (Tactdep[j] + TS[j,n] <= Tactdep[n]);
 }   
      
     
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   