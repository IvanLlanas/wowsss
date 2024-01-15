start_time=$SECONDS
sleep 5
elapsed=$(( SECONDS - start_time ))
echo $elapsed
echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')


   _start_time=$SECONDS
sleep 10
   _elapsed=$(( SECONDS - start_time ))
      echo "   "--- $(date -ud "@$elapsed" +'%Hh %Mm %Ss')
