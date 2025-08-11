--电子镭射破坏龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),1,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1093),2) 
	--Must be Fusion Summoned
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)   
	--Destroy all other cards on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,0})
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
s.listed_series={0x1093}
function s.cfilter(c)
	return c:IsSetCard(0x1093) and c:IsReleasable()
end
function s.filter(c)
	return (c:IsSetCard(0x93) or c:IsSetCard(0x94)) and c:IsSpellTrap() and c:IsAbleToGraveAsCost()
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,1,nil,1,tp,HINTMSG_TOGRAVE,nil,nil,true)
	if #sg==0 then return false end
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local mg=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #mg>0 then
		mg:Merge(sg)
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
	return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	local sg=g:Clone()
	local mg=sg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	sg:Sub(mg)
	Duel.SendtoGrave(sg,REASON_COST)
	Duel.Release(mg,REASON_COST)
	g:DeleteGroup()
	sg:DeleteGroup()
	mg:DeleteGroup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.ftarget)
	e1:SetLabel(c:GetFieldID())
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(c,nil,tp,1,0,aux.Stringid(id,2),nil)
end
function s.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function s.rfilter(c,tp,atk)
	return c:IsFaceup() and c:IsSummonPlayer(1-tp) and c:GetAttack()>atk and c:IsAbleToRemove() 
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.rfilter,1,nil,tp,e:GetHandler():GetAttack()) end
	local g=eg:Filter(s.rfilter,nil,tp,e:GetHandler():GetAttack())
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end