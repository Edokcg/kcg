--Numeron Direct
local s,id=GetID()
function s.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77402960,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_NUMERON_NETWORK}
s.listed_series={0x14b}

function s.filter1(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,0,1,nil)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsAttackBelow(1000) and c:IsSetCard(0x14b)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		(Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>3 
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,4,nil,e,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end	
	local count=0
	local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	if ft1>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,4,4,nil,e,tp)
		if g:GetCount()>0 then
			local fid=c:GetFieldID()
			Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			local g2=Duel.GetOperatedGroup()
			for tc in aux.Next(g2) do
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				tc:CompleteProcedure()
			end
			g2:KeepAlive()
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_PHASE+PHASE_END)
			e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetReset(RESET_PHASE+PHASE_END)
			e0:SetCountLimit(1)
			e0:SetLabel(fid)
			e0:SetLabelObject(g2)
			e0:SetCondition(s.rmcon)
			e0:SetOperation(s.rmop)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function s.rmfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.rmfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
