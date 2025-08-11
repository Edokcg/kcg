--Scripted by Eerie Code
--Raidraptor - Satellite Cannon Falcon
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_WINGEDBEAST),8,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Reduce ATK
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3,false,EFFECT_MARKER_DETACH_XMAT)
end
s.listed_series={0xba}

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetChainLimit(s.chainlm)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xba) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

function s.cost(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c,e)
	return c:HasNonZeroAttack() and (not e or not c:IsImmuneToEffect(e))
end
function s.atkfilter(c)
	return c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.HasNonZeroAttack,tp,0,LOCATION_MZONE,1,nil) 
		and Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.operation(e,tp,ep,eg,ev,re,r,rp)
	local mg=Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_MZONE,nil,e)
	local rc=Duel.GetMatchingGroupCount(s.atkfilter,tp,LOCATION_GRAVE,0,nil)
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetFirst()
	if mg==0 or rc==0 then return end
	repeat
		local code=ct:GetCode()
		Duel.Hint(HINT_CARD,0,code)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,e)
		local tc=tg:GetFirst()
		if tc then
			Duel.HintSelection(tg)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		else return
		end
		rc=rc-1
		ct=g:GetNext()
	until rc<=0 or not Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,e) 
		or not Duel.SelectYesNo(tp,210)
end
