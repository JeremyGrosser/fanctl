with Controller;

procedure Sim is
begin
   Controller.Initialize;
   for I in 1 .. 30 loop
      Controller.Update;
   end loop;
end Sim;
