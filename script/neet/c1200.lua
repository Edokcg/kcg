--大薰风飞龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WIND),2,2)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetCondition(function(e) return e:GetHandlerPlayer()~=Duel.GetTurnPlayer() end)
	e0:SetTarget(function(e,c) return c:IsSetCard(0x10) end)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCondition(function(e) return e:GetHandlerPlayer()==Duel.GetTurnPlayer() end)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--Deck Hand Tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Synchro.GustoCondition(f1,min1,max1,f2,min2,max2,sub1,sub2,req1,req2,reqm))
	e2:SetTarget(Synchro.GustoTarget(f1,min1,max1,f2,min2,max2,sub1,sub2,req1,req2,reqm))
	e2:SetOperation(Synchro.Operation)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(function(e,c) return c:IsSetCard(0x10) and c:IsType(TYPE_SYNCHRO  ) end)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	e4:SetOperation(s.repop)
	c:RegisterEffect(e4)
end
s.listed_series={0x10}
function s.filter(c)
	return c:IsCode(id) and c:GetFlagEffect(id)==0 and not c:IsDisabled() and not c:IsForbidden()
end
function Synchro.GustoCondition(f1,min1,max1,f2,min2,max2,sub1,sub2,req1,req2,reqm)
	return  function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()

				if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) then return false end
				local mt=c:GetMetatable()
				local val=mt.synchro_parameters
				local f1,min1,max1,f2,min2,max2,sub1,sub2,req1,req2,reqm=table.unpack(val)
				local dg
				local lv=c:GetLevel()
				local g
				local mgchk
				if sub1 then
					sub1=aux.OR(sub1,function(_c) return _c:IsHasEffect(30765615) and (not f1 or f1(_c,c,SUMMON_TYPE_SYNCHRO|MATERIAL_SYNCHRO,tp)) end)
				else
					sub1=function(_c) return _c:IsHasEffect(30765615) and (not f1 or f1(_c,c,SUMMON_TYPE_SYNCHRO|MATERIAL_SYNCHRO,tp)) end
				end
				if mg then
					dg=mg

					local dhg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK+LOCATION_HAND,0,c,TYPE_TUNER)
					mg:Merge(dhg)

					g=mg:Filter(Card.IsCanBeSynchroMaterial,c,c)
					mgchk=true
				else
					local function synchmatfilter(mc)
						local handmatfilter=mc:IsHasEffect(EFFECT_SYNCHRO_MAT_FROM_HAND)
						local handmatvalue=nil
						if handmatfilter then handmatvalue=handmatfilter:GetValue() end
						return (mc:IsLocation(LOCATION_MZONE) and mc:IsFaceup()
							and (mc:IsControler(tp) or mc:IsCanBeSynchroMaterial(c)))
							or (handmatfilter and handmatfilter:CheckCountLimit(tp) and handmatvalue(handmatfilter,mc,c))
					end
					dg=Duel.GetMatchingGroup(synchmatfilter,tp,LOCATION_MZONE|LOCATION_HAND,LOCATION_MZONE,c)

					local dhg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK+LOCATION_HAND,0,c,TYPE_TUNER)
					dg:Merge(dhg)

					g=dg:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					mgchk=false
				end
				local pg=Auxiliary.GetMustBeMaterialGroup(tp,dg,tp,c,g,REASON_SYNCHRO)
				if not g:Includes(pg) or pg:IsExists(aux.NOT(Card.IsCanBeSynchroMaterial),1,nil,c) then return false end
				if smat then
					if smat:IsExists(aux.NOT(Card.IsCanBeSynchroMaterial),1,nil,c) then return false end
					pg:Merge(smat)
					g:Merge(smat)
				end
				if g:IsExists(Synchro.CheckFilterChk,1,nil,f1,f2,sub1,sub2,c,tp) then
					--if there is a monster with EFFECT_SYNCHRO_CHECK (Genomix Fighter/Mono Synchron)
					local g2=g:Clone()
					if not mgchk then
						local thg=g2:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
						local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
						for thc in aux.Next(thg) do
							local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
							local val=te:GetValue()
							local ag=hg:Filter(function(mc) return val(te,mc,c) end,nil) --tuner
							g2:Merge(ag)
						end
					end
					local res=g2:IsExists(Synchro.CheckP31,1,nil,g2,Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup(),f1,sub1,f2,sub2,min1,max1,min2,max2,req1,req2,reqm,lv,c,tp,pg,mgchk,min,max)
					local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					aux.ResetEffects(hg,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					Duel.AssumeReset()
					return res
				else
					--no race change
					local tg
					local ntg
					if mgchk then
						tg=g:Filter(Synchro.TunerFilter,nil,f1,sub1,c,tp)
						ntg=g:Filter(Synchro.NonTunerFilter,nil,f2,sub2,c,tp)
					else
						tg=g:Filter(Synchro.TunerFilter,nil,f1,sub1,c,tp)
						ntg=g:Filter(Synchro.NonTunerFilter,nil,f2,sub2,c,tp)
						local thg=tg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
						thg:Merge(ntg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO))
						local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
						for thc in aux.Next(thg) do
							local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
							local val=te:GetValue()
							local thag=hg:Filter(function(mc) return Synchro.TunerFilter(mc,f1,sub1,c,tp) and val(te,mc,c) end,nil) --tuner
							local nthag=hg:Filter(function(mc) return Synchro.NonTunerFilter(mc,f2,sub2,c,tp) and val(te,mc,c) end,nil) --non-tuner
							tg:Merge(thag)
							ntg:Merge(nthag)
						end
					end
					local lv=c:GetLevel()
					local res=tg:IsExists(Synchro.CheckP41,1,nil,tg,ntg,Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup(),min1,max1,min2,max2,req1,req2,reqm,lv,c,tp,pg,mgchk,min,max)
					local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					aux.ResetEffects(hg,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
					return res
				end
				return false
			end
end
function Synchro.GustoTarget(f1,min1,max1,f2,min2,max2,sub1,sub2,req1,req2,reqm)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local mt=c:GetMetatable()
				local val=mt.synchro_parameters
				local f1,min1,max1,f2,min2,max2,sub1,sub2,req1,req2,reqm=table.unpack(val)
				local sg=Group.CreateGroup()
				local lv=c:GetLevel()
				local mgchk
				local g
				local dg
				if sub1 then
					sub1=aux.OR(sub1,function(_c) return _c:IsHasEffect(30765615) and (not f1 or f1(_c,c,SUMMON_TYPE_SYNCHRO|MATERIAL_SYNCHRO,tp)) end)
				else
					sub1=function(_c) return _c:IsHasEffect(30765615) and (not f1 or f1(_c,c,SUMMON_TYPE_SYNCHRO|MATERIAL_SYNCHRO,tp)) end
				end
				if mg then
					mgchk=true
					local dhg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK+LOCATION_HAND,0,c,TYPE_TUNER)
					mg:Merge(dhg)
					dg=mg
					g=mg:Filter(Card.IsCanBeSynchroMaterial,c,c)
				else
					mgchk=false
					local function synchmatfilter(mc)
						local handmatfilter=mc:IsHasEffect(EFFECT_SYNCHRO_MAT_FROM_HAND)
						local handmatvalue=nil
						if handmatfilter then handmatvalue=handmatfilter:GetValue() end
						return (mc:IsLocation(LOCATION_MZONE) and mc:IsFaceup()
							and (mc:IsControler(tp) or mc:IsCanBeSynchroMaterial(c)))
							or (handmatfilter and handmatfilter:CheckCountLimit(tp) and handmatvalue(handmatfilter,mc,c))
					end
					dg=Duel.GetMatchingGroup(synchmatfilter,tp,LOCATION_MZONE|LOCATION_HAND,LOCATION_MZONE,c)

					local dhg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK+LOCATION_HAND,0,c,TYPE_TUNER)
					dg:Merge(dhg)

					g=dg:Filter(Card.IsCanBeSynchroMaterial,nil,c)
				end
				local pg=Auxiliary.GetMustBeMaterialGroup(tp,dg,tp,c,g,REASON_SYNCHRO)
				if smat then
					pg:Merge(smat)
					g:Merge(smat)
				end
				local tg
				local ntg
				if mgchk then
					tg=g:Filter(Synchro.TunerFilter,nil,f1,sub1,c,tp)
					ntg=g:Filter(Synchro.NonTunerFilter,nil,f2,sub2,c,tp)
				else
					tg=g:Filter(Synchro.TunerFilter,nil,f1,sub1,c,tp)
					ntg=g:Filter(Synchro.NonTunerFilter,nil,f2,sub2,c,tp)
					local thg=tg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO)
					thg:Merge(ntg:Filter(Card.IsHasEffect,nil,EFFECT_HAND_SYNCHRO))
					local hg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,c)
					for thc in aux.Next(thg) do
						local te=thc:GetCardEffect(EFFECT_HAND_SYNCHRO)
						local val=te:GetValue()
						local thag=hg:Filter(function(mc) return Synchro.TunerFilter(mc,f1,sub1,c,tp) and val(te,mc,c) end,nil) --tuner
						local nthag=hg:Filter(function(mc) return Synchro.NonTunerFilter(mc,f2,sub2,c,tp) and val(te,mc,c) end,nil) --non-tuner
						tg:Merge(thag)
						ntg:Merge(nthag)
					end
				end
				local lv=c:GetLevel()
				local tsg=Group.CreateGroup()
				local selectedastuner=Group.CreateGroup()
				if g:IsExists(Synchro.CheckFilterChk,1,nil,f1,f2,sub1,sub2,c,tp) then
					local ntsg=Group.CreateGroup()
					local tune=true
					local g2=Group.CreateGroup()
					while #ntsg<max2 do
						local cancel=false
						local finish=false
						if tune then
							cancel=not mgchk and Duel.IsSummonCancelable() and #tsg==0
							local g3=ntg:Filter(Synchro.CheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqm,lv,c,tp,pg,mgchk,min,max)
							g2=g:Filter(Synchro.CheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,req2,reqm,lv,c,tp,pg,mgchk,min,max)
							if #g3>0 and #tsg>=min1 and tsg:IsExists(Synchro.TunerFilter,#tsg,nil,f1,sub1,c,tp) and (not req1 or req1(tsg,c,tp)) then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,false,cancel)
							if not tc then
								if #tsg>=min1 and tsg:IsExists(Synchro.TunerFilter,#tsg,nil,f1,sub1,c,tp) and (not req1 or req1(tsg,c,tp))
									and ntg:Filter(Synchro.CheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqm,lv,c,tp,pg,mgchk,min,max):GetCount()>0 then tune=false
								else
									return false
								end
							end
							if not sg:IsContains(tc) then
								if g3:IsContains(tc) then
									ntsg:AddCard(tc)
									tune = false
								else
									tsg:AddCard(tc)
								end
								selectedastuner:AddCard(tc)
								sg:AddCard(tc)
								if tc:IsHasEffect(EFFECT_SYNCHRO_CHECK) then
									local teg={tc:GetCardEffect(EFFECT_SYNCHRO_CHECK)}
									for i=1,#teg do
										local te=teg[i]
										local tg=g:Filter(function(mc) return te:GetValue()(te,mc) end,nil)
									end
								end
							else
								selectedastuner:RemoveCard(tc)
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
								if not sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_CHECK) then
									Duel.AssumeReset()
								end
							end
							if g:FilterCount(Synchro.CheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,req2,reqm,lv,c,tp,pg,mgchk,min,max)==0 or #tsg>=max1 then
								tune=false
							end
						else
							if (#ntsg>=min2 and (not req2 or req2(ntsg,c,tp)) and (not reqm or reqm(sg,c,tp))
								and ntsg:IsExists(Synchro.NonTunerFilter,#ntsg,nil,f2,sub2,c,tp)
								and sg:Includes(pg) and Synchro.CheckP43(tsg,ntsg,sg,lv,c,tp)) then
									finish=true
							end
							cancel = (not mgchk and Duel.IsSummonCancelable()) and #sg==0
							g2=g:Filter(Synchro.CheckP32,sg,g,tsg,ntsg,sg,f2,sub2,min2,max2,req2,reqm,lv,c,tp,pg,mgchk,min,max)
							if #g2==0 then break end
							local g3=g:Filter(Synchro.CheckP31,sg,g,tsg,ntsg,sg,f1,sub1,f2,sub2,min1,max1,min2,max2,req1,req2,reqm,lv,c,tp,pg,mgchk,min,max)
							if #g3>0 and #(ntsg-selectedastuner)==0 and #tsg<max1 then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,finish,cancel)
							if not tc then
								if #ntsg>=min2 and (not req2 or req2(ntsg,c,tp)) and (not reqm or reqm(sg,c,tp))
									and sg:Includes(pg) and Synchro.CheckP43(tsg,ntsg,sg,lv,c,tp) then break end
								return false
							end
							if not selectedastuner:IsContains(tc) then
								if not sg:IsContains(tc) then
									ntsg:AddCard(tc)
									sg:AddCard(tc)
									if tc:IsHasEffect(EFFECT_SYNCHRO_CHECK) then
										local teg={tc:GetCardEffect(EFFECT_SYNCHRO_CHECK)}
										for i=1,#teg do
											local te=teg[i]
											local tg=g:Filter(function(mc) return te:GetValue()(te,mc) end,nil)
										end
									end
								else
									ntsg:RemoveCard(tc)
									sg:RemoveCard(tc)
									if not sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_CHECK) then
										Duel.AssumeReset()
									end
								end
							elseif #(ntsg-selectedastuner)==0 then
								tune=true
								selectedastuner:RemoveCard(tc)
								ntsg:RemoveCard(tc)
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
							end
						end
					end
					Duel.AssumeReset()
				else
					local ntsg=Group.CreateGroup()
					local tune=true
					local g2=Group.CreateGroup()
					while #ntsg<max2 do
						local cancel=false
						local finish=false
						if tune then
							cancel=not mgchk and Duel.IsSummonCancelable() and #tsg==0
							local g3=ntg:Filter(Synchro.CheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqm,lv,c,tp,pg,mgchk,min,max)
							g2=tg:Filter(Synchro.CheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,req2,reqm,lv,c,tp,pg,mgchk,min,max)
							if #g3>0 and #tsg>=min1 and (not req1 or req1(tsg,c,tp)) then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,finish,cancel)
							if not tc then
								if #tsg>=min1 and (not req1 or req1(tsg,c,tp))
									and ntg:Filter(Synchro.CheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqm,lv,c,tp,pg,mgchk,min,max):GetCount()>0 then tune=false
								else
									return false
								end
							else
								if not sg:IsContains(tc) then
									if g3:IsContains(tc) then
										ntsg:AddCard(tc)
										tune = false
									else
										tsg:AddCard(tc)
									end
									selectedastuner:AddCard(tc)
									sg:AddCard(tc)
								else
									selectedastuner:RemoveCard(tc)
									tsg:RemoveCard(tc)
									sg:RemoveCard(tc)
								end
							end
							if tg:FilterCount(Synchro.CheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,req2,reqm,lv,c,tp,pg,mgchk,min,max)==0 or #tsg>=max1 then
								tune=false
							end
						else
							if #ntsg>=min2 and (not req2 or req2(ntsg,c,tp)) and (not reqm or reqm(sg,c,tp))
								and sg:Includes(pg) and Synchro.CheckP43(tsg,ntsg,sg,lv,c,tp) then
								finish=true
							end
							cancel=not mgchk and Duel.IsSummonCancelable() and #sg==0
							g2=ntg:Filter(Synchro.CheckP42,sg,ntg,tsg,ntsg,sg,min2,max2,req2,reqm,lv,c,tp,pg,mgchk,min,max)
							if #g2==0 then break end
							local g3=tg:Filter(Synchro.CheckP41,sg,tg,ntg,tsg,ntsg,sg,min1,max1,min2,max2,req1,req2,reqm,lv,c,tp,pg,mgchk,min,max)
							if #g3>0 and #(ntsg-selectedastuner)==0 and #tsg<max1 then
								g2:Merge(g3)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
							local tc=Group.SelectUnselect(g2,sg,tp,finish,cancel)
							if not tc then
								if #ntsg>=min2 and (not req2 or req2(ntsg,c,tp)) and (not reqm or reqm(sg,c,tp))
									and sg:Includes(pg) and Synchro.CheckP43(tsg,ntsg,sg,lv,c,tp) then break end
								return false
							end
							if not selectedastuner:IsContains(tc) then
								if not sg:IsContains(tc) then
									ntsg:AddCard(tc)
									sg:AddCard(tc)
								else
									ntsg:RemoveCard(tc)
									sg:RemoveCard(tc)
								end
							elseif #(ntsg-selectedastuner)==0 then
								tune=true
								selectedastuner:RemoveCard(tc)
								ntsg:RemoveCard(tc)
								tsg:RemoveCard(tc)
								sg:RemoveCard(tc)
							end
						end
					end
				end
				local hg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
				aux.ResetEffects(hg,EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
				if sg then
					local subtsg=tsg:Filter(function(_c) return sub1 and sub1(_c,c,SUMMON_TYPE_SYNCHRO|MATERIAL_SYNCHRO,tp) and ((f1 and not f1(_c,c,SUMMON_TYPE_SYNCHRO|MATERIAL_SYNCHRO,tp)) or not _c:IsType(TYPE_TUNER)) end,nil)
					local subc=subtsg:GetFirst()
					while subc do
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_ADD_TYPE)
						e1:SetValue(TYPE_TUNER)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						subc:RegisterEffect(e1,true)
						subc=subtsg:GetNext()
					end
					sg:KeepAlive()
					e:SetLabelObject(sg)

					--这玩意放在Synchro.Operation会不会好一点
					local regg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
					if regg then
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
						local regc=regg:Select(tp,1,1,nil):GetFirst()
						regc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
					end
					return true
				else return false end
			end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x10) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end