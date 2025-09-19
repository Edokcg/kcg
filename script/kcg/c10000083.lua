--神之进化
local s,id=GetID()
function s.initial_effect(c)
	--场上幻神兽族怪兽变为创造神族怪兽并加攻防
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
-----------------------------------------------------------------------
s.listed_names={21208154,62180201,57793869,10000000,10000010,10000020,30604579,67098114,93483212}

function s.filter(c)
	return c:IsFaceup() and c:IsOriginalRace(RACE_DIVINE) 
    and ((c:GetGodLevel()>=0 and c:GetGodLevel()<3) or (c:IsCode(10000000,10000010,10000020) and not c:IsCode(823,820,83)))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		local code=0
        local godlv=tc:GetGodLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(1000)
		tc:RegisterEffect(e2,true)
        if not tc:IsCode(10000000,10000010,10000020) then
            local ae = {tc:IsHasEffect(805)}
            for _, aec in ipairs(ae) do
                aec:Reset()
            end
            local e3=Effect.CreateEffect(c)
            e3:SetDescription(aux.Stringid(id,godlv))
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
            e3:SetCode(805)
            e3:SetValue(godlv+1)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e3,true)
        end

		if tc:IsCode(10000000,10000010,10000020) then
			local ocode=tc:GetOriginalCode()
			if tc:IsCode(10000000) then code=820 end
			if tc:IsCode(10000010) then code=83 end
			if tc:IsCode(10000020) then code=823 end
			tc:SetEntityCode(code,nil,nil,tc:GetOriginalType()&~TYPE_TOKEN,nil,nil,nil,nil,nil,nil,nil,nil,true)
		elseif tc:IsCode(21208154,62180201,57793869) then
			--To Graveyard
			local e5=Effect.CreateEffect(c)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e5:SetCategory(CATEGORY_TOGRAVE)
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e5:SetCode(EVENT_ATTACK_ANNOUNCE)
			e5:SetTarget(s.tgtg)
			e5:SetOperation(s.tgop)
			tc:RegisterEffect(e5,true)
		elseif tc:IsCode(30604579,67098114,93483212) then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_SUMMON)
			e1:SetCondition(s.condition1)
			e1:SetTarget(s.target1)
			e1:SetOperation(s.activate1)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EVENT_FLIP_SUMMON)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EVENT_SPSUMMON)
			tc:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(c)
			e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
			e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e4:SetType(EFFECT_TYPE_QUICK_O)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EVENT_CHAINING)
			e4:SetCondition(s.condition1)
			e4:SetTarget(s.target1)
			e4:SetOperation(s.activate1)
			tc:RegisterEffect(e4,true)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_LEAVE_FIELD_P)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetCondition(s.regcondition1)
			e0:SetOperation(s.regop)
			tc:RegisterEffect(e0,true)
		end
	end
end

function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0 and rp==1-tp
end
function s.sfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
    Duel.ClearOperationInfo(0)
    e:SetCategory(te:GetCategory())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function s.regcondition1(e,tp,eg,ep,ev,re,r,rp)
	return re~=e
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if re~=e then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
end

function s.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function s.tgfilter(c,p)
	return Duel.IsPlayerCanSendtoGrave(p,c) and not c:IsType(TYPE_TOKEN)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(tgfilter,1-tp,LOCATION_MZONE,0,1,nil,1-tp) end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(1-tp,tgfilter,1-tp,LOCATION_MZONE,0,1,1,nil,1-tp)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE+REASON_EFFECT)
	end
end