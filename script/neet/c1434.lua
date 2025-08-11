--幻魔的继承者(neet)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,{6007213,32491822,69890967},aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--Apply effects if Fusion Summoned with specific materials
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1a:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e1a:SetOperation(s.operation)
	c:RegisterEffect(e1a)
	--Material Check
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_SINGLE)
	e1b:SetCode(EFFECT_MATERIAL_CHECK)
	e1b:SetValue(s.valcheck)
	e1b:SetLabelObject(e1a)
	c:RegisterEffect(e1b)   
	--Cannot be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
s.listed_names={6007213,32491822,69890967}
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST|REASON_MATERIAL)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local flag=0
	if g:IsExists(Card.IsCode,1,nil,6007213) then flag=flag+1 end
	if g:IsExists(Card.IsCode,1,nil,32491822) then flag=flag+2 end
	if g:IsExists(Card.IsCode,1,nil,69890967) then flag=flag+4 end
	e:GetLabelObject():SetLabel(flag)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabel()
	local c=e:GetHandler()
	if (flag&1)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e1)
		--Increase ATK
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(function(e) return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		e2:SetValue(s.atkval)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
	if (flag&2)>0 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(s.efilter2)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e3)
		--Increase ATK
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(function(e) return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
		e4:SetReset(RESET_EVENT|RESETS_STANDARD)
		e4:SetValue(4000)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if (flag&4)>0 then
		--pierce
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_PIERCE)
		e10:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e10)
		--Increase ATK
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCondition(function(e) return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
		e6:SetReset(RESET_EVENT|RESETS_STANDARD)
		e6:SetValue(4000)
		c:RegisterEffect(e6)
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.atkfilter(c)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
function s.efilter2(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end