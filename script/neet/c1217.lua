--光芒使者 土星(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	s.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),2,nil,nil,nil)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.desreptg)
	e2:SetOperation(s.desrepop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(s.tg)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
end
function s.AddLinkProcedure(c,f,min,max,specialchk,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1174)
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(s.AddLinkCon(f,min,max,specialchk))
	e1:SetTarget(s.AddLinkTg(f,min,max,specialchk))
	e1:SetOperation(s.AddLinkOp(f,min,max,specialchk))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function s.rmlkfilter(c,lc)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeLinkMaterial(lc) and c:IsFaceup() and c:IsAbleToDeck()
end
function s.AddLinkCon(f,minc,maxc,specialchk)
	return  function(e,c,must,g,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				end
				local rmg=Duel.GetMatchingGroup(s.rmlkfilter,tp,LOCATION_REMOVED,0,nil,c)
				if rmg then
					g:Merge(rmg)
				end
				local mg=g:Filter(Link.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_LINK)
				if must then mustg:Merge(must) end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				if mustg:IsExists(aux.NOT(Link.ConditionFilter),1,nil,f,c,tp) or #mustg>max then return false end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_LINK)
				tg:Match(Link.ConditionFilter,nil,f,c,tp)
				local mg_tg=mg+tg
				local res=mg_tg:Includes(mustg) and #mustg<=max
				if res then
					if #mustg==max then
						local sg=Group.CreateGroup()
						res=mustg:IsExists(Link.CheckRecursive,1,sg,tp,sg,mg_tg,c,min,max,f,specialchk,mg,emt)
					elseif #mustg<max then
						local sg=mustg
						res=mg_tg:IsExists(Link.CheckRecursive,1,sg,tp,sg,mg_tg,c,min,max,f,specialchk,mg,emt)
					end
				end
				aux.DeleteExtraMaterialGroups(emt)
				return res
			end
end
function s.AddLinkTg(f,minc,maxc,specialchk)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				end
				local rmg=Duel.GetMatchingGroup(s.rmlkfilter,tp,LOCATION_REMOVED,0,nil,c)
				if rmg then
					g:Merge(rmg)
				end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				local mg=g:Filter(Link.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_LINK)
				if must then mustg:Merge(must) end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_LINK)
				tg:Match(Link.ConditionFilter,nil,f,c,tp)
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				local mg_tg=mg+tg
				while #sg<max do
					local filters={}
					if #sg>0 then
						Link.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg_tg,mg_tg,c,min,max,f,specialchk,mg,emt,filters)
					end
					local cg=mg_tg:Filter(Link.CheckRecursive,sg,tp,sg,mg_tg,c,min,max,f,specialchk,mg,emt,{table.unpack(filters)})
					if #cg==0 then break end
					finish=#sg>=min and #sg<=max and Link.CheckGoal(tp,sg,c,min,f,specialchk,filters)
					cancel=not og and Duel.IsSummonCancelable() and #sg==0
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local tc=Group.SelectUnselect(cg,sg,tp,finish,cancel,1,1)
					if not tc then break end
					if #mustg==0 or not mustg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
						else
							sg:RemoveCard(tc)
						end
					end
				end
				if #sg>0 then
					local filters={}
					Link.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg_tg,mg_tg,c,min,max,f,specialchk,mg,emt,filters)
					sg:KeepAlive()
					e:SetLabelObject({sg,filters,emt})
					return true
				else
					aux.DeleteExtraMaterialGroups(emt)
					return false
				end
			end
end
function s.AddLinkOp(f,minc,maxc,specialchk)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,must,g,min,max)
				local g,filt,emt=table.unpack(e:GetLabelObject())
				for _,ex in ipairs(filt) do
					if ex[3]:GetValue() then
						ex[3]:GetValue()(1,SUMMON_TYPE_LINK,ex[3],ex[1]&g,c,tp)
						if ex[3]:CheckCountLimit(tp) then
							ex[3]:UseCountLimit(tp,1)
						end
					end
				end
				for tc in g:Iter() do
					local formud_eff=tc:IsHasEffect(50366775)
					if formud_eff then
						local res1=tc:IsCanBeLinkMaterial(c,tp) and (not f or f(tc,c,SUMMON_TYPE_LINK|MATERIAL_LINK,tp))
						local label={formud_eff:GetLabel()}
						for i=1,#label-1,2 do
							tc:AssumeProperty(label[i],label[i+1])
						end
						local res2=tc:IsCanBeLinkMaterial(c,tp) and (not f or f(tc,c,SUMMON_TYPE_LINK|MATERIAL_LINK,tp))
						if not res2 or (res1 and res2 and not Duel.SelectEffectYesNo(tp,tc)) then
							Duel.AssumeReset()
						end
					end
				end
				c:SetMaterial(g)
				local rg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
				g:Sub(rg)
				Duel.SendtoDeck(rg,nil,2,REASON_MATERIAL+REASON_LINK)
				rg:DeleteGroup()
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
				aux.DeleteExtraMaterialGroups(emt)
			end
end
function s.repfilter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE)
		and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetLinkedGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(s.repfilter,1,nil,e,tp)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=c:GetLinkedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=g:FilterSelect(tp,s.repfilter,1,1,nil,e,tp)
		e:SetLabelObject(sg:GetFirst())
		return true
	else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	if tc:IsControler(1-tp) then
	   Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,2800)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2800,REASON_EFFECT)
	Duel.Recover(1-tp,2800,REASON_EFFECT)
end