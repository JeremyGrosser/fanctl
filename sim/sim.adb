with Controller;

procedure Sim is
begin
   Controller.Initialize;
   for I in 1 .. 25 loop
      Controller.Update;
   end loop;
end Sim;
